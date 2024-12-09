# 학습된 모델 사용
from ultralytics import YOLO
import logging

logging.getLogger("ultralytics").setLevel(logging.WARNING)
# Load a YOLOv8n PyTorch model
model = YOLO("Project/Jetson/AI/model/best.pt")
results = model(["Project/node/public/plant.jpg"])  # return a list of Results objects
# Process results list
most = -1
grade = -1
for result in results:
    boxes = result.boxes  # Boxes object for bounding box outputs
    # masks = result.masks  # Masks object for segmentation masks outputs
    # keypoints = result.keypoints  # Keypoints object for pose outputs
    # probs = result.probs  # Probs object for classification outputs
    # obb = result.obb  # Oriented boxes object for OBB outputs
#    result.show()  # display to screen
    # result.save(filename="result.jpg")  # save to disk
    # 결과 문자열로 출력
    cls = boxes.cls
    conf = boxes.conf
    cls_dict = result.names
    for cls_number, conf in zip(cls, conf):
        conf_number = float(conf.item())
        cls_number_int = int(cls_number.item())
        cls_name = cls_dict[cls_number_int]
        # 예측정확도가 최고인것만 추출
        if most < conf_number:
            most = conf_number
            grade = cls_number_int
        
    if grade != -1:
        print(cls_dict[grade],most)
        if grade==0 or grade==2:
            model1 = YOLO("Project/Jetson/AI/model/best1.pt")
            results1 = model1(["Project/node/public/plant.jpg"])  # return a list of Results objects
            most1 = -1
            grade1 = -1
            for result in results1:
                boxes = result.boxes  # Boxes object for bounding box outputs
                masks = result.masks  # Masks object for segmentation masks outputs
                keypoints = result.keypoints  # Keypoints object for pose outputs
                probs = result.probs  # Probs object for classification outputs
                obb = result.obb  # Oriented boxes object for OBB outputs
                # result.show()  # display to screen
                result.save(filename="result.jpg")  # save to disk
                cls = result.boxes.cls
                conf = result.boxes.conf
                cls_dict = result.names
                for cls_number, conf in zip(cls, conf):
                    conf_number = float(conf.item())
                    cls_number_int = int(cls_number.item())
                    cls_name = cls_dict[cls_number_int]
                    # 예측정확도가 최고인것만 추출
                    if most < conf_number:
                        most = conf_number
                        grade = cls_number_int
                if grade1 != -1:
                    print(cls_dict[grade1],most1)
                else:
                    print("No disease")
        else:
            print("No disease")
    else:
        print("No Plant")
        print("No disease")
    