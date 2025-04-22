import tkinter as tk
from tkinter import ttk, messagebox, simpledialog
import cv2
import numpy as np
import time
from PIL import Image, ImageTk
import pyzbar.pyzbar as pyzbar
import threading
import queue
import uuid

class BultoDetectorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Detector de Bultos con Lector de Códigos de Barras")
        self.root.geometry("1000x700")
        
        # Variables
        self.camera_active = False
        self.bulto_count = 0
        self.last_barcode = ""
        self.detected_barcodes = []
        self.min_contour_area = 2000  # Área mínima para detectar un bulto
        self.detection_cooldown = 1.0  # Tiempo de espera entre detecciones (segundos)
        self.last_detection_time = 0
        
        # Para redimensionamiento de video
        self.frame_width = 640
        self.frame_height = 480
        self.aspect_ratio = self.frame_width / self.frame_height
        
        # Variables para la zona de detección
        self.zone_x1 = 100  # Coordenada x inicial 
        self.zone_x2 = 500  # Coordenada x final
        self.zone_y1 = 100  # Coordenada y inicial
        self.zone_y2 = 400  # Coordenada y final
        self.setting_zone = False
        self.current_point = None
        
        # Variables para la sensibilidad de detección
        self.sensitivity = 50  # Valor de sensibilidad (0-100)
        
        # Control de objetos detectados
        self.tracked_objects = {}  # Formato: {id: (timestamp, already_counted)}
        self.object_timeout = 2.0  # Tiempo en segundos antes de que un objeto pueda ser contado de nuevo
        
        # Para detección estable
        self.reference_frame = None
        self.frame_count = 0
        
        # Cola para comunicación segura entre hilos
        self.queue = queue.Queue()
        
        # Configurar interfaz
        self.setup_ui()
        
        # Asegurar que la ventana se haya dibujado antes de iniciar la cámara
        self.root.update_idletasks()
        
        # Intentar inicializar la cámara al inicio
        try:
            self.cap = cv2.VideoCapture(0)
            if not self.cap.isOpened():
                messagebox.showerror("Error", "No se pudo acceder a la cámara web.")
                return
                
            # Establecer la resolución de captura
            self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, self.frame_width)
            self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, self.frame_height)
        except Exception as e:
            messagebox.showerror("Error", f"Error al inicializar la cámara: {str(e)}")
            return
            
        # Iniciar captura de video
        self.camera_active = True
        self.video_thread = threading.Thread(target=self.process_video, daemon=True)
        self.video_thread.start()
        
        # Actualizar interfaz periódicamente
        self.update_ui()
        
        # Vincular evento de redimensionamiento
        self.root.bind("<Configure>", self.on_resize)

    def setup_ui(self):
        # Panel principal
        main_panel = ttk.PanedWindow(self.root, orient=tk.HORIZONTAL)
        main_panel.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        # Panel izquierdo - Video
        left_frame = ttk.Frame(main_panel)
        main_panel.add(left_frame, weight=3)
        
        # Frame para el video para poder redimensionar
        self.video_frame = ttk.Frame(left_frame, borderwidth=2, relief="sunken")
        self.video_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Etiqueta para mostrar el video
        self.video_label = ttk.Label(self.video_frame)
        self.video_label.pack(fill=tk.BOTH, expand=True)
        
        # Añadir interacción con el mouse para la zona de detección
        self.video_label.bind("<Button-1>", self.on_click)
        
        # Panel derecho - Información y controles
        right_frame = ttk.Frame(main_panel)
        main_panel.add(right_frame, weight=1)
        
        # Estilo para los bordes
        s = ttk.Style()
        s.configure('Panel.TFrame', relief='solid', borderwidth=1)
        
        # Control de sensibilidad (arriba del contador)
        sensitivity_frame = ttk.Frame(right_frame, style='Panel.TFrame')
        sensitivity_frame.pack(fill=tk.X, padx=5, pady=5)
        
        ttk.Label(sensitivity_frame, text="Sensibilidad:", font=("Arial", 12)).pack(padx=10, pady=5)
        
        sensitivity_control_frame = ttk.Frame(sensitivity_frame)
        sensitivity_control_frame.pack(fill=tk.X, padx=10, pady=5)
        
        self.sensitivity_scale = ttk.Scale(sensitivity_control_frame, from_=1, to=100, 
                                           orient=tk.HORIZONTAL, length=150,
                                           command=self.update_sensitivity)
        self.sensitivity_scale.set(self.sensitivity)
        self.sensitivity_scale.pack(side=tk.LEFT, fill=tk.X, expand=True)
        
        self.sensitivity_label = ttk.Label(sensitivity_control_frame, text="50")
        self.sensitivity_label.pack(side=tk.LEFT, padx=5)
        
        # Botón para configurar zona
        self.zone_button = ttk.Button(sensitivity_control_frame, text="Configurar Zona", command=self.start_zone_setup)
        self.zone_button.pack(side=tk.RIGHT, padx=5)
        
        # Botón para capturar fondo de referencia
        ref_button = ttk.Button(sensitivity_frame, text="Capturar Fondo de Referencia", command=self.capture_reference)
        ref_button.pack(padx=10, pady=5)
        
        # Contador de bultos
        counter_frame = ttk.Frame(right_frame, style='Panel.TFrame')
        counter_frame.pack(fill=tk.X, padx=5, pady=5)
        
        ttk.Label(counter_frame, text="Bultos detectados:", font=("Arial", 12)).pack(padx=10, pady=5)
        self.counter_label = ttk.Label(counter_frame, text="0", font=("Arial", 24, "bold"))
        self.counter_label.pack(padx=10, pady=10)
        
        # Botón para reiniciar contador
        ttk.Button(counter_frame, text="Reiniciar contador", command=self.reset_counter).pack(padx=10, pady=10)
        
        # Información de código de barras
        barcode_frame = ttk.Frame(right_frame, style='Panel.TFrame')
        barcode_frame.pack(fill=tk.X, padx=5, pady=5)
        
        ttk.Label(barcode_frame, text="Último código de barras:", font=("Arial", 12)).pack(padx=10, pady=5)
        self.barcode_label = ttk.Label(barcode_frame, text="Ninguno", font=("Arial", 10))
        self.barcode_label.pack(padx=10, pady=5)
        
        # Lista de códigos detectados
        log_frame = ttk.Frame(right_frame, style='Panel.TFrame')
        log_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        ttk.Label(log_frame, text="Registro de detecciones:", font=("Arial", 12)).pack(padx=10, pady=5)
        
        # Scrollbar y listbox para mostrar historial
        scrollbar = ttk.Scrollbar(log_frame)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        self.log_listbox = tk.Listbox(log_frame, yscrollcommand=scrollbar.set, font=("Arial", 10))
        self.log_listbox.pack(fill=tk.BOTH, expand=True, padx=10, pady=5)
        scrollbar.config(command=self.log_listbox.yview)
        
        # Barra de estado
        self.status_bar = ttk.Label(self.root, text="Listo", relief=tk.SUNKEN, anchor=tk.W)
        self.status_bar.pack(side=tk.BOTTOM, fill=tk.X)

    def on_resize(self, event):
        # Solo procesar eventos del frame principal
        if event.widget == self.root:
            pass
            
    def capture_reference(self):
        """Captura un frame de referencia para la detección por diferencia"""
        if hasattr(self, 'current_frame'):
            self.reference_frame = self.current_frame.copy() 
            self.queue.put(("status", "Fondo de referencia capturado. Coloque ahora los bultos en la zona."))
        else:
            self.queue.put(("status", "Error: No hay imagen disponible para capturar como referencia."))

    def update_sensitivity(self, value):
        value = float(value)
        self.sensitivity = int(value)
        self.sensitivity_label.configure(text=str(self.sensitivity))
        
        # Ajustar área mínima basada en la sensibilidad
        self.min_contour_area = 10000 - (self.sensitivity * 80)
        if self.min_contour_area < 1000:
            self.min_contour_area = 1000
        
    def start_zone_setup(self):
        if self.setting_zone:
            self.setting_zone = False
            self.zone_button.configure(text="Configurar Zona")
            self.queue.put(("status", "Configuración de zona finalizada"))
        else:
            self.setting_zone = True
            self.current_point = "zone_x1y1"  # Primer punto a configurar
            self.zone_button.configure(text="Cancelar Config. Zona")
            self.queue.put(("status", "Haga clic para definir la esquina superior izquierda de la zona"))
    
    def on_click(self, event):
        if not self.setting_zone:
            return
        
        # Obtener dimensiones de la imagen mostrada
        label_width = self.video_label.winfo_width()
        label_height = self.video_label.winfo_height()
        
        # Verificar si el tamaño es válido
        if label_width <= 1 or label_height <= 1:
            return
            
        # Calcular la proporción de escala
        if label_width / label_height > self.aspect_ratio:
            # Limitado por altura
            new_height = label_height
            new_width = int(new_height * self.aspect_ratio)
            
            # Calcular desplazamiento horizontal
            offset_x = (label_width - new_width) // 2
            offset_y = 0
            
            # Ajustar las coordenadas del clic
            x = event.x - offset_x
            y = event.y
            
            # Verificar que el clic esté dentro de la imagen
            if x < 0 or x >= new_width:
                return
                
            # Calcular coordenadas en el frame original
            x = int((x / new_width) * self.frame_width)
            y = int((y / new_height) * self.frame_height)
        else:
            # Limitado por ancho
            new_width = label_width
            new_height = int(new_width / self.aspect_ratio)
            
            # Calcular desplazamiento vertical
            offset_x = 0
            offset_y = (label_height - new_height) // 2
            
            # Ajustar las coordenadas del clic
            x = event.x
            y = event.y - offset_y
            
            # Verificar que el clic esté dentro de la imagen
            if y < 0 or y >= new_height:
                return
                
            # Calcular coordenadas en el frame original
            x = int((x / new_width) * self.frame_width)
            y = int((y / new_height) * self.frame_height)
        
        # Aplicar las coordenadas calculadas
        if self.current_point == "zone_x1y1":
            self.zone_x1 = x
            self.zone_y1 = y
            self.current_point = "zone_x2y2"
            self.queue.put(("status", f"Primera coordenada ({x},{y}). Haga clic para definir la esquina inferior derecha"))
        elif self.current_point == "zone_x2y2":
            self.zone_x2 = x
            self.zone_y2 = y
            
            # Asegurar que x2 > x1 y y2 > y1
            if self.zone_x1 > self.zone_x2:
                self.zone_x1, self.zone_x2 = self.zone_x2, self.zone_x1
            if self.zone_y1 > self.zone_y2:
                self.zone_y1, self.zone_y2 = self.zone_y2, self.zone_y1
            
            self.setting_zone = False
            self.zone_button.configure(text="Configurar Zona")
            self.queue.put(("status", f"Zona configurada: ({self.zone_x1},{self.zone_y1}) - ({self.zone_x2},{self.zone_y2})"))
            
            # Capturar nuevo fondo de referencia cuando se cambia la zona
            self.reference_frame = None
        
    def reset_counter(self):
        self.bulto_count = 0
        self.queue.put(("status", "Contador reiniciado"))
        self.queue.put(("counter", self.bulto_count))
        self.tracked_objects.clear()
        
    def process_video(self):
        """Procesa el video en un hilo separado"""
        while self.camera_active:
            ret, frame = self.cap.read()
            if not ret:
                self.queue.put(("status", "Error al capturar video"))
                time.sleep(0.5)  # Pequeña pausa antes de intentar de nuevo
                continue
                
            # Guardar el frame actual para referencia
            self.current_frame = frame.copy()
                
            # Procesar el frame para detección de bultos
            processed_frame = self.detect_bultos(frame.copy())
            
            # Buscar códigos de barras
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            
            # Aplicar mejoras para la detección de códigos de barras
            clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
            enhanced = clahe.apply(gray)
            
            # Intentar detectar códigos en diferentes versiones de la imagen
            for img_version in [frame, cv2.cvtColor(enhanced, cv2.COLOR_GRAY2BGR)]:
                barcodes = pyzbar.decode(img_version)
                if barcodes:
                    break
            
            for barcode in barcodes:
                barcode_data = barcode.data.decode('utf-8')
                barcode_type = barcode.type
                
                # Dibujar rectángulo alrededor del código de barras
                (x, y, w, h) = barcode.rect
                cv2.rectangle(processed_frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
                
                # Mostrar datos del código en el frame
                text = f"{barcode_type}: {barcode_data}"
                cv2.putText(processed_frame, text, (x, y - 10), 
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
                
                # Si es un código nuevo, agregarlo a la lista
                if barcode_data != self.last_barcode:
                    self.last_barcode = barcode_data
                    timestamp = time.strftime("%H:%M:%S")
                    log_entry = f"{timestamp} - Bulto #{self.bulto_count} - {barcode_type}: {barcode_data}"
                    self.queue.put(("barcode", barcode_data))
                    self.queue.put(("log", log_entry))
            
            # Convertir a formato para Tkinter
            cv2image = cv2.cvtColor(processed_frame, cv2.COLOR_BGR2RGB)
            
            # Obtener dimensiones actuales del label
            label_width = self.video_label.winfo_width()
            label_height = self.video_label.winfo_height()
            
            if label_width > 1 and label_height > 1:  # Asegurar que los valores sean válidos
                # Calcular el nuevo tamaño manteniendo la proporción
                if label_width / label_height > self.aspect_ratio:
                    # Limitado por altura
                    new_height = label_height
                    new_width = int(new_height * self.aspect_ratio)
                else:
                    # Limitado por ancho
                    new_width = label_width
                    new_height = int(new_width / self.aspect_ratio)
                
                # Redimensionar la imagen
                cv2image = cv2.resize(cv2image, (new_width, new_height), interpolation=cv2.INTER_LANCZOS4)
            
            # Convertir a formato compatible con tkinter
            img = Image.fromarray(cv2image)
            imgtk = ImageTk.PhotoImage(image=img)
            
            # Poner en la cola para actualizar la UI
            self.queue.put(("image", imgtk))
            
            # Control de FPS
            time.sleep(0.033)  # Aproximadamente 30 FPS
            
    def detect_bultos(self, frame):
        # Dibujar zona de detección
        cv2.rectangle(frame, (self.zone_x1, self.zone_y1), (self.zone_x2, self.zone_y2), (0, 255, 255), 2)

        if self.zone_x1 >= self.zone_x2 or self.zone_y1 >= self.zone_y2:
            return frame

        roi = frame[self.zone_y1:self.zone_y2, self.zone_x1:self.zone_x2]
        if roi.size == 0:
            return frame

        if self.reference_frame is not None:
            ref_roi = self.reference_frame[self.zone_y1:self.zone_y2, self.zone_x1:self.zone_x2]
            if roi.shape != ref_roi.shape:
                self.reference_frame = self.current_frame.copy()
                return frame
            diff = cv2.absdiff(roi, ref_roi)
            diff_gray = cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY)
            _, thresh = cv2.threshold(diff_gray, 30, 255, cv2.THRESH_BINARY)
            kernel = np.ones((5, 5), np.uint8)
            thresh = cv2.dilate(thresh, kernel, iterations=2)
            thresh = cv2.erode(thresh, kernel, iterations=1)
        else:
            gray_roi = cv2.cvtColor(roi, cv2.COLOR_BGR2GRAY)
            blurred = cv2.GaussianBlur(gray_roi, (5, 5), 0)
            edges = cv2.Canny(blurred, 50, 150)
            kernel = np.ones((5, 5), np.uint8)
            edges = cv2.dilate(edges, kernel, iterations=1)
            thresh = edges

        contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        current_time = time.time()
        current_objects = []

        for i, contour in enumerate(contours):
            area = cv2.contourArea(contour)
            print(f"[DEBUG] Contorno {i}: Área = {area}")

            if area < self.min_contour_area:
                print(f"Contorno descartado por área insuficiente: {area}")
                continue
            
            print(f"Contorno válido detectado: {area}")
            peri = cv2.arcLength(contour, True)
            approx = cv2.approxPolyDP(contour, 0.04 * peri, True)

            if 4 <= len(approx) <= 8:
                x, y, w, h = cv2.boundingRect(contour)
                abs_x = x + self.zone_x1
                abs_y = y + self.zone_y1
                aspect_ratio = float(w) / h
                print(f"[DEBUG] AR = {aspect_ratio:.2f} | Posición: ({abs_x},{abs_y}) Tamaño: {w}x{h}")

                if 0.2 <= aspect_ratio <= 5.0:
                    current_objects.append((abs_x, abs_y, w, h))
                    cv2.rectangle(frame, (abs_x, abs_y), (abs_x + w, abs_y + h), (255, 0, 0), 2)
                    cv2.putText(frame, f"AR:{aspect_ratio:.2f}", (abs_x, abs_y + h + 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 0), 1)
                    cv2.putText(frame, f"A:{int(area)}", (abs_x, abs_y + h + 30), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (200, 200, 0), 1)

        found_objects = {obj_id: False for obj_id in self.tracked_objects.keys()}

        for abs_x, abs_y, w, h in current_objects:
            object_matched = False

            # 🔁 Menos precisión: redondeamos posición y tamaño
            current_obj_id = f"{round(abs_x, -1)}_{round(abs_y, -1)}_{round(w, -1)}_{round(h, -1)}"
            print(f"[DEBUG] ID Generado: {current_obj_id}")

            for tracked_id, (last_time, already_counted) in list(self.tracked_objects.items()):
                parts = tracked_id.split('_')
                if len(parts) >= 4:
                    t_x, t_y, t_w, t_h = map(int, parts[:4])
                    x_overlap = max(0, min(abs_x + w, t_x + t_w) - max(abs_x, t_x))
                    y_overlap = max(0, min(abs_y + h, t_y + t_h) - max(abs_y, t_y))
                    overlap_area = x_overlap * y_overlap
                    min_area = min(w * h, t_w * t_h)

                    if overlap_area > 0.3 * min_area:
                        object_matched = True
                        found_objects[tracked_id] = True
                        self.tracked_objects[current_obj_id] = (current_time, already_counted)

                        if not already_counted:
                            self.bulto_count += 1
                            self.queue.put(("counter", self.bulto_count))
                            current_timestamp = time.strftime("%H:%M:%S")
                            log_entry = f"{current_timestamp} - Bulto #{self.bulto_count} detectado (tamaño: {w}x{h})"
                            self.queue.put(("log", log_entry))
                            self.queue.put(("status", f"Nuevo bulto detectado: {w}x{h} píxeles"))
                            self.tracked_objects[current_obj_id] = (current_time, True)
                            cv2.rectangle(frame, (abs_x, abs_y), (abs_x + w, abs_y + h), (0, 0, 255), 2)
                            cv2.putText(frame, f"Bulto #{self.bulto_count}", (abs_x, abs_y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 2)
                        else:
                            cv2.rectangle(frame, (abs_x, abs_y), (abs_x + w, abs_y + h), (0, 255, 0), 2)
                            cv2.putText(frame, "Contado", (abs_x, abs_y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

                        if tracked_id != current_obj_id:
                            del self.tracked_objects[tracked_id]
                        break

            if not object_matched:
                self.tracked_objects[current_obj_id] = (current_time, False)

        current_time = time.time()
        for tracked_id in list(found_objects.keys()):
            if not found_objects[tracked_id]:
                last_time, _ = self.tracked_objects[tracked_id]
                if current_time - last_time > 3.0:
                    del self.tracked_objects[tracked_id]

        return frame


    def update_ui(self):
        """Actualiza la interfaz de usuario con datos de la cola"""
        try:
            # Limitar el número de mensajes procesados por iteración
            messages_to_process = min(10, self.queue.qsize())
            
            for _ in range(messages_to_process):
                if self.queue.empty():
                    break
                    
                message_type, data = self.queue.get_nowait()
                
                if message_type == "image":
                    self.video_label.configure(image=data)
                    self.video_label.image = data
                elif message_type == "counter":
                    self.counter_label.configure(text=str(data))
                elif message_type == "barcode":
                    self.barcode_label.configure(text=data)
                elif message_type == "log":
                    self.log_listbox.insert(tk.END, data)
                    self.log_listbox.see(tk.END)  # Desplazar hacia abajo
                elif message_type == "status":
                    self.status_bar.configure(text=data)
        except Exception as e:
            print(f"Error al actualizar UI: {str(e)}")
            
        # Programar la próxima actualización
        self.root.after(5, self.update_ui)
        
    def on_closing(self):
        """Maneja el cierre de la aplicación"""
        self.camera_active = False
        time.sleep(0.5)  # Dar tiempo a que el hilo termine
        if hasattr(self, 'cap'):
            self.cap.release()
        self.root.destroy()

if __name__ == "__main__":
    try:
        # Verificar dependencias antes de iniciar
        required_modules = {
            "cv2": "opencv-python",
            "numpy": "numpy",
            "PIL": "pillow",
            "pyzbar": "pyzbar"
        }
        
        missing_modules = []
        for module, package in required_modules.items():
            try:
                __import__(module)
            except ImportError:
                missing_modules.append(f"{module} ({package})")
        
        if missing_modules:
            print("Faltan módulos necesarios. Instale los siguientes paquetes:")
            for module in missing_modules:
                print(f"  pip install {module}")
            input("Presione Enter para salir...")
            exit(1)
            
        # Iniciar la aplicación
        root = tk.Tk()
        app = BultoDetectorApp(root)
        root.protocol("WM_DELETE_WINDOW", app.on_closing)
        root.mainloop()
        
    except Exception as e:
        messagebox.showerror("Error", f"Error inesperado: {str(e)}")