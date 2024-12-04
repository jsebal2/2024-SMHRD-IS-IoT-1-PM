# 학습된 모델 사용
from ultralytics import YOLO

# Load a YOLOv8n PyTorch model
model = YOLO("model/best.pt")

# Export the model
model.export(format="engine")  # creates 'yolov8n.engine'

# Load the exported TensorRT model
# trt_model = YOLO("yolov8n.engine")

# Run inference
# results = trt_model("https://ultralytics.com/images/bus.jpg")
