# 엑ㅠ러이터를 모아서 실행
import sys

# node에서 받은 파라미터
kind = sys.argv[1]
try:
    if kind=='light':
        print("light 실행")
    elif kind =='pan':
        print("pan 실행")
    elif kind == 'pump':
        print("pump 실행")
    else:
        raise Exception("해당하는 엑츄러이터가 없습니다.")
except Exception as e:
    print("Error : ",e)