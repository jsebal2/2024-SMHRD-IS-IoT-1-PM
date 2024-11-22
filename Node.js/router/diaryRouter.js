const express = require("express");
const router = express.Router();
const conn = require("../config/db");
const id = "uid_134092"
// 다이어리 저장
// 받을 데이터 형식 
// {"제목" : "wwwwwwwwww", "내용":"ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ", "date":"yyyymmdd"}
router.post("/save",(req,res)=>{
    console.log("input | ",req.query);
    const data = req.query;
    let sql = "insert into tbi_diary (title,content,created_at,user_id) values ( ?,?,?,?,? );"
    conn.query(sql,[data.제목, data.내용, data.date,id],(err,rows)=>{
        console.log("rows | ",rows);
        console.log("err  | ",err);
        if (rows)   res.json({"result":true});
        else res.json({"result" : false});
        
    })
})
// 다이어리 불러오기
// 받은 데이터 형식
// {"date": yyyymmdd, user_id : "EEEE"}
router.post("/load",(req,res)=>{
    console.log(req.query);
    const data = req.query;
    if( data.user_id === id){
        let sql = "select title, content from tbi_diary where created_at = ? and user_id =?;"
        conn.query(sql,[data.date,data.user_id],(err,rows)=>{
            console.log("rows | ",rows);
            console.log("err  | ",err);
            if (rows)   res.json({"result":true, "rows":rows});
            else res.json({"result" : false});
            
        })
    }else res.json({"result":false, "err" : "not my data"})
})

// 다이어리 수정
// 받은 데이터 형식
// {"title" : "WWWWWW" , "content": "dddddddd", "date": yyyymmdd, user_id : "EEEE"}
router.post("/change",(req,res)=>{
    console.log(req.query);
    const data = req.query;
    if( data.user_id === id){
        let sql = "update tbi_diary set title=?, content=? where created_at = ? and user_id =?;"
        conn.query(sql,[data.title, data.content, data.date,data.user_id],(err,rows)=>{
            console.log("rows | ",rows);
            console.log("err  | ",err);
            if (rows)   res.json({"result":true, "rows":rows});
            else res.json({"result" : false});
            ㅣ
        })
    }else res.json({"result":false, "err" : "not my data"})
})

// 다이어리 삭제
// 받은 데이터 형식
// {"date": yyyymmdd, user_id : "EEEE"}
router.post("/change",(req,res)=>{
    console.log(req.query);
    const data = req.query;
    if( data.user_id === id){
        let sql = "delete from tbi_diary where created_at = ? and user_id =?;"
        conn.query(sql,[data.date,data.user_id],(err,rows)=>{
            console.log("rows | ",rows);
            console.log("err  | ",err);
            if (rows)   res.json({"result":true, "rows":rows});
            else res.json({"result" : false});
            
        })
    }else res.json({"result":false, "err" : "not my data"})
})

module.exports = router; 
