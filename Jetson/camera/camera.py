import cv2
import datetime
import time
import Jetson.camera.savePic as savePic

def gstreamer_pipeline(sensor_id=0, capture_width=1280, capture_height=720,
                       display_width=640, display_height=480, framerate=15, flip_method=0):
    return (
        "nvarguscamerasrc sensor-id={} ! "
        "video/x-raw(memory:NVMM), width=(int){}, height=(int){}, "
        "format=(string)NV12, framerate=(fraction){}/1 ! "
        "nvvidconv flip-method={} ! "
        "video/x-raw, width=(int){}, height=(int){}, format=(string)BGRx ! "
        "videoconvert ! video/x-raw, format=(string)BGR ! appsink".format(
            sensor_id, capture_width, capture_height, framerate, flip_method, display_width, display_height
        )
    )

pipeline = gstreamer_pipeline()

def picture():
    result = "fail"
    try:
        cap = cv2.VideoCapture(pipeline, cv2.CAP_GSTREAMER)
        start = datetime.datetime.now()
        if not cap.isOpened():
            print("Unable to open CSI camera.")

        print("Press 'q' to exit.")
        while True:
            ret, frame = cap.read()
            if not ret:
                print("Failed to capture image.")
                break
            end = datetime.datetime.now()
            frame = cv2.putText(frame,start.strftime("%Y-%m-%d"),(15,25),cv2.FONT_HERSHEY_SIMPLEX,1,(0,0,225),2)
            cv2.imshow("CSI Camera", frame)
            if end >= start+datetime.timedelta(seconds=30):
                result = "save"
                break
            if cv2.waitKey(1) & 0xFF == ord('q'):
                result = "end"
                break 
    finally:    
        cv2.imwrite("/home/jetbot/Project/node/public/plant.jpg",frame)
        cap.release()
        cv2.destroyAllWindows()
        print(result)
        savePic.write_read("plant_mate_pic","/home/jetbot/Project/node/public/plant.jpg")
        return result

if __name__ =="__main__":
    picture()
