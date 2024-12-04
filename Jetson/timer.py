# 엑ㅠ러이터를 모아서 실행
import sys
import os
import threading
import time
import math

# node에서 받은 파라미터
time_ = int(sys.argv[1])  # 지속 시간
# kind = "pump"
command_file = str(os.getcwd())+"/Project/jetson/actu/pwm_command.txt"
print(command_file)
def flie(speed,lien):
    # 파일을 읽고 모든 줄을 리스트에 저장
    with open(command_file, 'r') as f:
        lines = f.readlines()
        # print(len(lines))

    # 두 번째 줄 수정 (인덱스는 1)
    lines[lien-1] = str(f"{speed}\n")  # 두 번째 줄에 쓸 내용

    # 수정된 내용을 파일에 다시 쓰기
    with open(command_file, 'w') as f:
        f.writelines(lines)
def PRINT(i):
    print(f"{i-1} 시간 남음")
def TIMER():
    timer = threading.Timer(10,TIMER) 
    timer.start()
    print(math.ceil(goal-time.time()))
    if time.time()>goal:
        timer.cancel()
        flie(0,1)

try:
    goal = time.time()+time_*60#*60
    TIMER()

except Exception as e:
    print("Error : ",e)