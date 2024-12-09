#-*-coding : utf-8-*-
import sys
sys.path.append("/home/jetbot/Project/Jetson/sensor")
import light, waterLavel

light1 = light.main()
water_level = waterLavel.main() 
temp = 30
humidity = 20
level = 2
date = 20
disease = 0
# print(light)
# print(temp)
# print(he)
print('{"light":%s,"temp":%f,"humidity":%f, "level" : %d, "date": %d, "water_level": %d, "disease" : %d}'%(light1,temp,humidity,level,date,water_level,disease))
