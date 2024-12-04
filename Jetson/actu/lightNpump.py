import time
import Jetson.GPIO as GPIO
import threading
import os

GPIO.setmode(GPIO.BOARD)
print(os.getcwd())
command_file = str(os.getcwd())+"/Project/jetson/actu/pwm_command.txt"
# 실제 핀 정의
#PWM PIN
ENA,ENB = 32,33
#GPIO PIN
IN1,IN2 = 31,29
IN3,IN4 = 24,22

# 핀 설정 함수
def setPinConfig(EN, INA, INB):        
    GPIO.setup(EN, GPIO.OUT)
    GPIO.setup(INA, GPIO.OUT)
    GPIO.setup(INB, GPIO.OUT)
    
    # 100khz 로 PWM 동작 시킴 
    pwm = GPIO.PWM(EN, 100) 
    
    # 우선 PWM 멈춤.   
    pwm.start(0) 
    return pwm

# 모터 제어 함수
def setMotorControl(pwm, INA, INB,speed,control=None):
    #모터 속도 제어 PWM
    pwm.ChangeDutyCycle(speed)
     # on
    if control == "ON":
        GPIO.output(INA, GPIO.HIGH)
        GPIO.output(INB, GPIO.LOW)
    # off
    elif control == "OFF":
        GPIO.output(INA, GPIO.LOW)
        GPIO.output(INB, GPIO.LOW)
    else:
        GPIO.output(INA, GPIO.HIGH)
        GPIO.output(INB, GPIO.LOW)

# 모터 제어함수 간단하게 사용하기 위해 한번더 래핑(감쌈)
def setMotor(pwmA, stat):
    #pwmA는 핀 설정 후 pwm 핸들을 리턴 받은 값이다.
    setMotorControl(pwmA, IN3, IN4, stat)
    
def pwm_control_thread(pwmA,pwmB):
    """PWM 제어 스레드: 파일에서 값을 읽어 모터 제어"""
    if not os.path.exists(command_file):
        with open(command_file, "w") as f:
            f.write("100\non")  # 초기 PWM 값 0
    last_modified = os.path.getmtime(command_file)  # 초기 수정 시간 설정

    while True:
        try:
            # 현재 수정 시간 가져오기
            current_modified = os.path.getmtime(command_file)
            if current_modified != last_modified:
                last_modified = current_modified  # 수정 시간 업데이트
                # 파일 읽기
                with open(command_file, "r") as f:
                    bright = f.readline().strip()
                    pump = f.readline().strip()
                # 값이 숫자이고 0~100 사이면 PWM 변경
                if bright.isdigit():
                    bright = int(bright)
                    if 0 <= bright <= 100:
                        setMotorControl(pwmB, IN3, IN4, bright)
                        print(f"bright 값이 {bright}로 업데이트되었습니다.")
                if pump.lower() == "on":
                    setMotorControl(pwmA,IN1,IN2,100)
                elif pump.lower() == "off":
                    setMotorControl(pwmA,IN1,IN2,0)
        except Exception as e:
            print(f"오류 발생: {e}")
        time.sleep(0.1)  # 0.1초마다 파일 확인
        
os.system("sudo busybox devmem 0x700031fc 32 0x45")
os.system("sudo busybox devmem 0x6000d504 32 0x2")
os.system("sudo busybox devmem 0x70003248 32 0x46")
os.system("sudo busybox devmem 0x6000d100 32 0x00")
GPIO.setwarnings(False)
pwmA = setPinConfig(ENA, IN1, IN2)  #pump
pwmB = setPinConfig(ENB, IN3, IN4)  #led


# 종료 신호를 위한 Event 객체 생성
stop_event = threading.Event()
# PWM 제어 스레드 시작
pwm_thread = threading.Thread(target=pwm_control_thread, args=(pwmA,pwmB))
pwm_thread.start()
try:
    while True:
        time.sleep(1) # 메인 루프 유지
except KeyboardInterrupt:
    print("프로그램 종료 중...")

finally:

    # PWM 정지 및 GPIO 정리
    pwmA.stop()
    GPIO.cleanup()
    print("GPIO 정리 완료")
