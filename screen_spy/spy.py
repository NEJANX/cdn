import pyautogui
import cv2
import numpy as np
from flask import Flask, Response
import time
import threading

app = Flask(__name__)

def generate_frames():
    while True:
        # Capture screenshot
        img = pyautogui.screenshot()

        # Convert screenshot to numpy array
        frame = np.array(img)

        # Convert RGB to BGR
        frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

        # Encode frame as JPEG
        _, jpeg = cv2.imencode('.jpg', frame)

        # Yield the frame in byte format
        yield (b'--frame\r\n' b'Content-Type: image/jpeg\r\n\r\n' + jpeg.tobytes() + b'\r\n')

        # Wait for 1/30 seconds
        time.sleep(1/30)

@app.route('/')
def index():
    return Response(generate_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    # Start Flask app in a separate thread
    threading.Thread(target=app.run, kwargs={'host':'0.0.0.0', 'port':50004}).start()
