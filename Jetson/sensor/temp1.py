import RPi.GPIO as GPIO
import time
import numpy as np
# DHT11 핀 설정
DHT_PIN = 17
data = np.zeros(40)       # DHT11로 40개의 bit (5 byte) 읽어오므로 40개 배열변수 준비
humidity = None       # 첫번째 byte인 습도데이터를 위한 변수
humidity2 = None      # 두번째 byte인 습도데이터를 위한 변수
temperature = None   # 세번째 byte인 온도데이터를 위한 변수
temperature2 = None  # 네번째 byte인 온도데이터를 위한 변수
checksum = None      # 다섯번째 byte인 checksum데이터를 위한 변수
expect = None 

# GPIO 설정
GPIO.setmode(GPIO.BCM)

# 전송되는 신호의 길이 확인
def confirm(pin, us,level): # 핀번호, 확인하는 시간, 확인하는 신호 레벨(HiGH,LOW)
    count = int(us / 10)    # 10us단위로 확인해서
    # 입력이 10 단위가 이니면 +1
    print(us)
    if ((us%10)>0): 
        count+=1
    ok = False
    for i in range(count):
        time.sleep(0.00001)
        print(GPIO.input(pin))
        if GPIO.input(pin)!=level:
            ok = True
            break
    if not ok:
        return -1
    return 0

def bit2byte (data):
    if len(data) !=8 :
        print("잘못된 배열의 크기")
        return -1
    else:
        v = int(0)
        for i in range(8):
            v +=data[i]<<(7-i)
        return v

# DHT11 데이터 읽기 함수
def read_dht11():
    
    humidity = -1
    temperature = -1
    
    GPIO.setup(DHT_PIN, GPIO.OUT)
    # 기기 측에서 먼저 low신호를 20ms,  high 신호를 20~40us 로 보내 통신 시작(feat.데이터 시트)
    GPIO.output(DHT_PIN, GPIO.LOW)
    time.sleep(0.02)  # 20ms 대기
    GPIO.output(DHT_PIN, GPIO.HIGH)
    time.sleep(0.00003)  # 40us 대기
    
    GPIO.setup(DHT_PIN, GPIO.IN)
    
    # 데이터 수신
    # 센서에서 low 80us, high 80us를 보내 데이터 전송의 시작을 알림
    time.sleep(0.00003)
    if confirm(DHT_PIN,80,GPIO.LOW): # 입력이 Low 80us가 아니면 -> 에러
        print("Error on start Low")
        return
    if confirm(DHT_PIN,80,GPIO.HIGH): # 입력이 HIGH 80us가 아니면 -> 에러
        print("Error on start High")
        return
    
    # 데이터 전송을 알리는 신호가 보내졌으면 40개의 비트를 전송
    # 데이터는 50us의 LOW신호 뒤에 HIGH신호가 26~28us이면 "0", 70us이면 "1"입니다
    for i in range(40):
        # DATA bit 앞에 50us의 LOW 신호 확인
        if confirm(DHT_PIN,50,GPIO.LOW):
            print("Error on Data Low")
            return
        # 50us 의 LOW신호 뒤에 HIGH신호의 길이 확인
        ok = False
        tick = int(0)
        # 0.00001 10us
        # 10us 주기로 8번 DATA라인이 HIGH인지 확인
        for j in range(8):
            if GPIO.input(DHT_PIN) != GPIO.HIGH:
                ok = True
                break
            time.sleep(0.00001)
            tick+=1
        if not ok :
            print("Error on Data Read")
            return
        data[i] = 1 if tick>3 else 0
    
    # if confirm(DHT_PIN,50,GPIO.LOW):
    #     print("Error on End of Reading")
    #     return
    
    humidity = bit2byte(data[0:8])
    humidity2 = bit2byte(data[8:16])
    temperature = bit2byte(data[16:24])
    temperature2 = bit2byte(data[24:32])
    checksum = bit2byte(data[32:40])
    
    expect = humidity+humidity2+temperature+temperature2
    if checksum != expect:
        print("there are some error on Transmission")
        humidity = -1
        temperature = -1
    
    data = []
    for i in range(0, 85):
        count = 0
        print(GPIO.input(DHT_PIN))
        while GPIO.input(DHT_PIN) == GPIO.LOW:
            count += 1
            if count > 100:
                break
        # print(count)
        data.append(count)

try:
    while True:
        read_dht11()
        if humidity is not None and temperature is not None:
            print(f'Humidity: {humidity}% Temperature: {temperature}°C')
        else:
            print('Failed to read data from DHT11 sensor')
        time.sleep(2)  # 2초 대기
except KeyboardInterrupt:
    pass
finally:
    GPIO.cleanup()
