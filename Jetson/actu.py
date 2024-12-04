# 엑ㅠ러이터를 모아서 실행
import sys
import os
import json

# node에서 받은 파라미터
kind = sys.argv[1]
speed = json.loads(sys.argv[2])
print(speed['time'])
# kind = "pump" 
command_file = str(os.getcwd())+"/Project/jetson/actu/pwm_command.txt"

def flie(speed,lien):
    # 파일을 읽고 모든 줄을 리스트에 저장
    with open(command_file, 'r') as f:
        lines = f.readlines()
        print(len(lines))

    # 두 번째 줄 수정 (인덱스는 1)
    lines[lien-1] = str(speed)  # 두 번째 줄에 쓸 내용

    # 수정된 내용을 파일에 다시 쓰기
    with open(command_file, 'w') as f:
        f.writelines(lines)
try:
    if kind=='light':           # pwm
        while True:
            new_speed = input("PWM 값 입력 (0-100, exit로 종료): ").strip()
            if new_speed.lower() == "exit":
                flie("exit",1)
                break
            if new_speed.isdigit():
                speed = int(new_speed)
                if 0 <= speed <= 100:
                    flie(speed, 1)
                else:
                    print("PWM 값은 0-100 사이여야 합니다.")
            else:
                print("유효한 숫자를 입력하세요.")
    elif kind == 'pump':        # on/off
        while True:
            new_speed = input("PWM 값 입력 (on/off, exit로 종료): ").strip()
            if new_speed.lower() == "exit":
                flie("exit",2)
                break
            else:
                flie(new_speed.lower(),2)

    else:
        raise Exception("해당하는 엑츄러이터가 없습니다.")
except Exception as e:
    print("Error : ",e)