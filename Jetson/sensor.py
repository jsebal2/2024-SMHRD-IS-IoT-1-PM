
# 센서값을 모아서 받아옴
light = 200
temp = 23
he = 20
level = 2
date = 20
water_level = 1 # 0은 물이 있다, 1은 물이 없다
disease = 0 # 0은 병이 없다, 1은 병이 있다.
# print(light)
# print(temp)
# print(he)
print('{"light":%f,"temp":%f,"humidity":%f, "level" : %d, "date": %d, "water_level": %d, "disease" : %d}'%(light,temp,he,level,date,water_level,disease))
