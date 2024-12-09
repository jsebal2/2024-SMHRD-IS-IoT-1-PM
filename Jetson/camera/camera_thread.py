import threading
import time
import schedule
import camera

schedule.every().day.at("14:00").do(camera.picture)

def run_schedule():
    while True:
        schedule.run_pending()
        time.sleep(1)

# 별도의 쓰레드에서 스케줄링 실행
schedule_thread = threading.Thread(target=run_schedule)
schedule_thread.daemon = True  # 프로그램 종료 시 함께 종료되도록 설정
schedule_thread.start()

