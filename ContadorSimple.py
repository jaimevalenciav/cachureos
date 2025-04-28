import cv2
import tkinter as tk
from tkinter import ttk
from tkinter import scrolledtext
from PIL import Image, ImageTk

class ContadorCajasApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Contador de Cajas")

        self.cap = cv2.VideoCapture(0)

        # Variables
        self.rect_start = (100, 100)
        self.rect_width = 200
        self.rect_height = 300
        self.line_x = self.rect_start[0] + self.rect_width // 2
        self.counter = 0
        self.crossed_ids = set()
        self.object_id = 0
        self.previous_positions = {}

        self.create_widgets()
        self.update_frame()

        # Evento resize ventana
        self.root.bind('<Configure>', self.on_resize)

    def create_widgets(self):
        # Crear dos frames principales
        self.video_frame = tk.Frame(self.root, bg="black")
        self.controls_frame = tk.Frame(self.root)

        self.video_frame.pack(side=tk.TOP, fill=tk.BOTH, expand=True)
        self.controls_frame.pack(side=tk.BOTTOM, fill=tk.BOTH)

        # Dentro del video_frame, el video
        self.video_label = tk.Label(self.video_frame, bg="black")
        self.video_label.pack(fill=tk.BOTH, expand=True)

        # Dentro de controles, botones + log
        button_frame = tk.Frame(self.controls_frame)
        button_frame.pack(fill=tk.X, pady=5)

        self.label_counter = ttk.Label(button_frame, text="Cajas contadas: 0")
        self.label_counter.pack(side=tk.LEFT, padx=5)

        self.btn_set_rect = ttk.Button(button_frame, text="Establecer Rectángulo", command=self.set_rectangle)
        self.btn_set_rect.pack(side=tk.LEFT, padx=5)

        self.btn_reset = ttk.Button(button_frame, text="Resetear Contador", command=self.reset_counter)
        self.btn_reset.pack(side=tk.LEFT, padx=5)

        # Log de mensajes
        self.text_log = scrolledtext.ScrolledText(self.controls_frame, height=8, state='disabled')
        self.text_log.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)

    def on_resize(self, event):
        # Al cambiar tamaño ventana, ajustamos los frames
        total_height = self.root.winfo_height()

        # 70% video / 30% controles
        video_height = int(total_height * 0.7)
        controls_height = total_height - video_height

        self.video_frame.config(height=video_height)
        self.controls_frame.config(height=controls_height)

    def set_rectangle(self):
        self.rect_start = (150, 100)
        self.rect_width = 300
        self.rect_height = 200
        self.line_x = self.rect_start[0] + self.rect_width // 2
        self.log_message("Rectángulo establecido manualmente.")

    def reset_counter(self):
        self.counter = 0
        self.label_counter.config(text=f"Cajas contadas: {self.counter}")
        self.crossed_ids.clear()
        self.previous_positions.clear()
        self.text_log.configure(state='normal')
        self.text_log.delete('1.0', tk.END)
        self.text_log.configure(state='disabled')
        self.log_message("Contador reiniciado.")

    def log_message(self, message):
        self.text_log.configure(state='normal')
        self.text_log.insert(tk.END, message + "\n")
        self.text_log.configure(state='disabled')
        self.text_log.yview(tk.END)

    def update_frame(self):
        ret, frame = self.cap.read()
        if not ret:
            self.root.after(10, self.update_frame)
            return

        # Redimensionar frame al tamaño actual del video_label
        label_width = self.video_label.winfo_width()
        label_height = self.video_label.winfo_height()

        if label_width > 10 and label_height > 10:
            frame = cv2.resize(frame, (label_width, label_height))

        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        blur = cv2.GaussianBlur(gray, (21, 21), 0)

        if not hasattr(self, 'prev_frame'):
            self.prev_frame = blur
            self.root.after(10, self.update_frame)
            return

        delta_frame = cv2.absdiff(self.prev_frame, blur)
        thresh = cv2.threshold(delta_frame, 30, 255, cv2.THRESH_BINARY)[1]
        dilated = cv2.dilate(thresh, None, iterations=2)
        contours, _ = cv2.findContours(dilated, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        x, y = self.rect_start
        cv2.rectangle(frame, (x, y), (x + self.rect_width, y + self.rect_height), (0, 255, 255), 2)
        self.line_x = x + self.rect_width // 2
        cv2.line(frame, (self.line_x, y), (self.line_x, y + self.rect_height), (255, 0, 0), 2)

        for contour in contours:
            if cv2.contourArea(contour) < 500:
                continue

            (bx, by, bw, bh) = cv2.boundingRect(contour)
            center_x = bx + bw // 2
            center_y = by + bh // 2

            if (x < center_x < x + self.rect_width) and (y < center_y < y + self.rect_height):
                cv2.rectangle(frame, (bx, by), (bx + bw, by + bh), (0, 255, 0), 2)

                obj_id = self.object_id
                self.object_id += 1
                self.previous_positions[obj_id] = center_x

                if self.previous_positions[obj_id] > self.line_x and center_x <= self.line_x:
                    if obj_id not in self.crossed_ids:
                        self.crossed_ids.add(obj_id)
                        self.counter += 1
                        self.label_counter.config(text=f"Cajas contadas: {self.counter}")
                        self.log_message(f"Caja cruzó la línea - ID {obj_id}")

        self.prev_frame = blur

        frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(frame_rgb)
        imgtk = ImageTk.PhotoImage(image=img)

        self.video_label.imgtk = imgtk
        self.video_label.configure(image=imgtk)

        self.root.after(30, self.update_frame)

    def on_close(self):
        self.cap.release()
        self.root.destroy()

if __name__ == "__main__":
    root = tk.Tk()
    root.geometry('1000x700')
    app = ContadorCajasApp(root)
    root.protocol("WM_DELETE_WINDOW", app.on_close)
    root.mainloop()
