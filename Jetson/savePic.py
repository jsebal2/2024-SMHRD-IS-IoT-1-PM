# Imports the Google Cloud client library
#pip install --upgrade google-cloud-storage
from google.cloud import storage
from dotenv import load_dotenv
import os
import pymysql
import datetime
# .env파일 사용 선언
load_dotenv()
bucket_name = "plant_mate_pic"
file_path = "C:/Users/smhrd/Desktop/실전프로젝트/code/node/public/pic1.png"
# 환경변수 설정
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]=os.environ.get("KEY_PATH")

def readSQL(file_name, file_ext):
    try:
        conn = pymysql.connect(host=os.environ.get("DB_HOST"),
                                port=int(os.environ.get("DB_PORT")),
                                user=os.environ.get("DB_USER"),
                                password=os.environ.get("DB_PW"),
                                db=os.environ.get("DB_DB"))
        cur = conn.cursor()
        # 파일사이즈 필요? diary_idx 삭제 요청
        sql = f"""INSERT INTO tbl_file (file_rname, file_ext, uploaded_at,diary_idx) 
        VALUES("{file_name}","{file_ext}",NOW(),1)"""
        # sql문 실행
        cur.execute(sql)
    except pymysql.err.InternalError as e:
        code, msg = e.args
        print(f"error [{code}] : {msg}")
    # 커밋
    conn.commit()
    # 연결 종료
    conn.close()    


def write_read(bucket_name, blob_name,file_path):
    """Write and read a blob from GCS using file-like IO"""
    # The ID of your GCS bucket
    # bucket_name = "your-bucket-name"
    
    # The ID of your new GCS object
    # blob_name = 저장될 파일명
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    blob = bucket.blob(f"pic_{today}.jpg")
    try:
        blob.upload_from_filename(file_path)
    except:
        print("fail saving image")
    readSQL("pic","jpg")
        
if __name__ == "__main__":
    write_read(bucket_name,"saveFileName",file_path)
