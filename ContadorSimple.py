import tkinter as tk
from tkinter import ttk
import cv2
from PIL import Image, ImageTk

class ContadorCajasApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Contador de Cajas")

        self.cap = cv2.VideoCapture(0)  # Usa la cámara 0

        # Variables
        self.rectangle_points = []
        self.setting_rectangle = False
        self.contador = 0

        # Layout
        self.setup_layout()

        # Empezar a actualizar frames
        self.update_frame()

    def setup_layout(self):
        # Frame para video
        self.video_frame = tk.Frame(self.root, bg="black")
        self.video_frame.place(relx=0, rely=0, relwidth=0.7, relheight=1)

        self.video_label = tk.Label(self.video_frame)
        self.video_label.pack(fill=tk.BOTH, expand=True)
        self.video_label.bind("<Button-1>", self.get_rectangle_point)

        # Frame para controles
        self.controls_frame = tk.Frame(self.root, bg="lightgray")
        self.controls_frame.place(relx=0.7, rely=0, relwidth=0.3, relheight=1)

        self.btn_set_rect = ttk.Button(self.controls_frame, text="Establecer Rectángulo", command=self.set_rectangle)
        self.btn_set_rect.pack(pady=10, padx=10, fill='x')

        self.btn_reset_counter = ttk.Button(self.controls_frame, text="Reiniciar Contador", command=self.reset_counter)
        self.btn_reset_counter.pack(pady=10, padx=10, fill='x')

        self.counter_label = ttk.Label(self.controls_frame, text="Cajas contadas: 0", font=("Arial", 16))
        self.counter_label.pack(pady=20)

        self.log_text = tk.Text(self.controls_frame, height=10)
        self.log_text.pack(pady=10, padx=10, fill='both', expand=True)

    def log(self, message):
        self.log_text.insert(tk.END, message + "\n")
        self.log_text.see(tk.END)

    def set_rectangle(self):
        self.rectangle_points = []
        self.setting_rectangle = True
        self.log("Haga click en dos puntos para definir el rectángulo.")

    def reset_counter(self):
        self.contador = 0
        self.counter_label.config(text=f"Cajas contadas: {self.contador}")
        self.log("Contador reiniciado.")

    def get_rectangle_point(self, event):
        if not self.setting_rectangle:
            return

        if len(self.rectangle_points) < 2:
            self.rectangle_points.append((event.x, event.y))
            self.log(f"Punto {len(self.rectangle_points)} establecido: {event.x}, {event.y}")

        if len(self.rectangle_points) == 2:
            self.setting_rectangle = False
            self.log(f"Rectángulo finalizado: {self.rectangle_points}")

    def update_frame(self):
        ret, frame = self.cap.read()
        if not ret:
            self.root.after(10, self.update_frame)
            return

        frame = cv2.flip(frame, 1)  # Voltear horizontal para que sea espejo

        # Redimensionar frame al tamaño del label
        label_width = self.video_label.winfo_width()
        label_height = self.video_label.winfo_height()

        if label_width > 0 and label_height > 0:
            frame = cv2.resize(frame, (label_width, label_height))

        # Detección simple de movimiento
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        blur = cv2.GaussianBlur(gray, (21, 21), 0)

        if not hasattr(self, 'prev_frame') or self.prev_frame.shape != blur.shape:
            self.prev_frame = blur
            self.display_frame(frame)
            self.root.after(10, self.update_frame)
            return

        delta_frame = cv2.absdiff(self.prev_frame, blur)
        thresh = cv2.threshold(delta_frame, 30, 255, cv2.THRESH_BINARY)[1]
        dilated = cv2.dilate(thresh, None, iterations=2)
        contours, _ = cv2.findContours(dilated, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        for contour in contours:
            if cv2.contourArea(contour) < 500:
                continue
            x, y, w, h = cv2.boundingRect(contour)
            # Dibujar bounding box en azul
            cv2.rectangle(frame, (x, y), (x + w, y + h), (255, 0, 0), 2)

            if len(self.rectangle_points) == 2:
                (x1, y1), (x2, y2) = self.rectangle_points
                # Asegurar orden correcto de coordenadas
                x_min, x_max = min(x1, x2), max(x1, x2)
                y_min, y_max = min(y1, y2), max(y1, y2)

                if y_min <= y <= y_max and x_min <= x + w//2 <= x_max:
                    # Si el centro de la caja cruza la línea azul
                    center_line_x = (x_min + x_max) // 2
                    if abs((x + w//2) - center_line_x) < 10:
                        self.contador += 1
                        self.counter_label.config(text=f"Cajas contadas: {self.contador}")
                        self.log(f"Caja contada en x={x+w//2}, y={y}")

        # Dibujar rectángulo amarillo y línea azul
        if len(self.rectangle_points) == 2:
            (x1, y1), (x2, y2) = self.rectangle_points
            x_min, x_max = min(x1, x2), max(x1, x2)
            y_min, y_max = min(y1, y2), max(y1, y2)

            cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), (0, 255, 255), 2)
            center_line_x = (x_min + x_max) // 2
            cv2.line(frame, (center_line_x, y_min), (center_line_x, y_max), (255, 0, 0), 2)

        self.prev_frame = blur
        self.display_frame(frame)
        self.root.after(10, self.update_frame)

    def display_frame(self, frame):
        img = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        img = Image.fromarray(img)
        imgtk = ImageTk.PhotoImage(image=img)
        self.video_label.imgtk = imgtk
        self.video_label.config(image=imgtk)

    def on_closing(self):
        self.cap.release()
        self.root.destroy()

if __name__ == "__main__":
    root = tk.Tk()
    app = ContadorCajasApp(root)
    root.protocol("WM_DELETE_WINDOW", app.on_closing)
    root.geometry("1200x700")  # Ventana inicial grande
    root.mainloop()
