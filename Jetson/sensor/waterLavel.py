#-*-coding : utf-8-*-

import Jetson.GPIO as GPIO
import time
water = 7

GPIO.setmode(GPIO.BOARD)
GPIO.setup(water,GPIO.IN)

def main():
    try:
        if GPIO.input(water) == GPIO.LOW:
            # print("low")
            return 0
        else:
            # print("high")
            return 1
    except KeyboardInterrupt:
        GPIO.cleanup()

if __name__ == "__main__":
    while 1:
        main()