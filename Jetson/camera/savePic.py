# Imports the Google Cloud client library
#pip install --upgrade google-cloud-storage
from google.cloud import storage
from dotenv import load_dotenv
import os
import pymysql
import datetime
import subprocess
# .env파일 사용 선언
load_dotenv()
bucket_name = "plant_mate_pic"
file_path = "/home/jetbot/Project/node/public/plant.jpg"
# 환경변수 설정
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]=str(os.environ.get("KEY_PATH"))

def readSQL(file_name, file_ext):
    print("readSQL")
    try:
        conn = pymysql.connect(host=os.environ.get("DB_HOST"),
                                port=int(os.environ.get("DB_PORT")),
                                user=os.environ.get("DB_USER"),
                                password=os.environ.get("DB_PW"),
                                db=os.environ.get("DB_DB"))
        cur = conn.cursor()
        print(datetime.datetime.now())
        # 파일사이즈 필요? diary_idx 삭제 요청
        sql = f"""INSERT INTO tbl_file (file_rname, file_ext, uploaded_at,diary_idx) VALUES("{file_name}","{file_ext}",date_format(Now(), '%Y-%m-%d'),1)"""
        # sql문 실행
        cur.execute(sql)
    except pymysql.err.InternalError as e:
        code, msg = e.args
        print(f"error [{code}] : {msg}")
    # 커밋
    conn.commit()
    # 연결 종료
    conn.close()    

def run_in_virtualenv(script_path):
    print("run_in_virtualenv")
    # 가상환경 경로 설정
    virtualenv_path = '/home/jetbot/plantmate/bin/activate'  # 가상환경의 Python 경로
    
    # 실행할 스크립트 경로
    script_path = os.path.abspath(script_path)
    
    # 가상환경에서 스크립트 실행
    result = subprocess.run(
            ['bash', '-c', f"source {virtualenv_path} && python3 {script_path}"], 
            # capture_output=True,  # 출력 캡처
            # text=True,  # 출력 텍스트로 받기 (바이너리로 받지 않고)
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            universal_newlines=True,
            check=True  # 오류 발생 시 예외 발생
        )
    
    # 표준 출력 (stdout)과 표준 오류 (stderr) 출력
    print("표준 출력 (stdout):")
    print(result.stdout.splitlines())  # 스크립트의 표준 출력 결과
    print("표준 오류 (stderr):")
    print(result.stderr)  # 오류 메시지 (있다면)
    
def write_read(bucket_name,file_path):
    print("write_read")
    """Write and read a blob from GCS using file-like IO"""
    # The ID of your GCS bucket
    # bucket_name = "your-bucket-name"
    
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    blob_name = f"pic_{today}"
    blob_ext = "jpg"
    blob = bucket.blob(f"{blob_name}.{blob_ext}")
    try:
        blob.upload_from_filename(file_path)
        readSQL(blob_name,blob_ext)
        run_in_virtualenv("/home/jetbot/Project/Jetson/AI/grade.py")
    except Exception as e:
        print("error : ",e)
        print("fail saving image")
        
if __name__ == "__main__":
    write_read(bucket_name,file_path)
