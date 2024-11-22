/**mysql 연결정보를 관리하는 파일    */
const mysql = require("mysql2");
const env = require("../.env");


// db에 연결할 정보들을 기입
const conn = mysql.createConnection({
                                        host :DB_HOST,
                                        port : DB_PORT,
                                        user : DB_USER,
                                        password : DB_PW,
                                        database : DB_DB
                                    })
//연결실행
conn.connect();


module.exports = conn;