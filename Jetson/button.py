import RPi.GPIO as GPIO
import os
from bleak import BleakScanner
import asyncio
button = 2

while True:
    if ( GPIO.input(button) == GPIO.HIGH ):        
        os.system("hciconfig hci0 piscan")
        # 블루투스 연결 확인
        if os.system("primary") :
            
            os.system("cd ~/Projects/node/")
            os.system("nodemon app.js")
    else:
        os.system("hciconfig hci0 noscan")
        
# import bluetooth

# server_sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)

# port = 1
# server_sock.bind(("", port))
# server_sock.listen(1)

# client_sock, address = server_sock.accept()
# print("Accepted connection from", address)

# data = client_sock.recv(1024)
# print("Received:", data)

# client_sock.close()
# server_sock.close()