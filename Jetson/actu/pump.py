import time
import Jetson.GPIO as GPIO
import threading
import os

GPIO.setmode(GPIO.BOARD)
command_file = "light_command.txt"
# 실제 핀 정의
#PWM PIN
ENA = 32  
#GPIO PIN
IN1 = 31
IN2 = 29  

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
def setMotorControl(pwm, INA, INB, control):

    #모터 속도 제어 PWM
    pwm.ChangeDutyCycle(100)#41.7  12v 입력시 5v
    # on
    if control == "ON":
        GPIO.output(INA, GPIO.HIGH)
        GPIO.output(INB, GPIO.LOW)
    # off
    elif control == "OFF":
        GPIO.output(INA, GPIO.LOW)
        GPIO.output(INB, GPIO.LOW)
        
                
# 모터 제어함수 간단하게 사용하기 위해 한번더 래핑(감쌈)
def setMotor(pwmA, stat):
    #pwmA는 핀 설정 후 pwm 핸들을 리턴 받은 값이다.
    setMotorControl(pwmA, IN1, IN2, stat)
    
def pwm_control_thread(pwm):
    """PWM 제어 스레드: 파일에서 값을 읽어 모터 제어"""
    if not os.path.exists(command_file):
        with open(command_file, "w") as f:
            f.write("100")  # 초기 PWM 값 0
    last_modified = os.path.getmtime(command_file)  # 초기 수정 시간 설정

    while True:
        try:
            # 현재 수정 시간 가져오기
            current_modified = os.path.getmtime(command_file)
            if current_modified != last_modified:
                last_modified = current_modified  # 수정 시간 업데이트
                # 파일 읽기
                with open(command_file, "r") as f:
                    f.readline()
                    speed = f.readline().strip()    # 두번째 줄 읽기
                # 값이 숫자이고 0~100 사이면 PWM 변경
                if speed.isdigit():
                    speed = int(speed)
                    if 0 <= speed <= 100:
                        setMotorControl(pwm, IN1, IN2, speed)
                        print(f"PWM 값이 {speed}로 업데이트되었습니다.")
        except Exception as e:
            print(f"오류 발생: {e}")
        time.sleep(0.1)  # 0.1초마다 파일 확인

try:
    GPIO.setwarnings(False)
    pwmA = setPinConfig(ENA, IN1, IN2)
    setMotor(pwmA,"ON")
    time.sleep(30)
    setMotor(pwmA,"OFF")
except KeyboardInterrupt:
    print("프로그램 종료 중...")

finally:
    # PWM 정지 및 GPIO 정리
    pwmA.stop()
    GPIO.cleanup()
    print("GPIO 정리 완료")