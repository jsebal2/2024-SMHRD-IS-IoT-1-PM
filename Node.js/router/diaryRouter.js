const express = require("express");
const router = express.Router();
const conn = require("../config/db");
const id = "test1"
// 다이어리 저장
// 받을 데이터 형식 
// {"제목" : "wwwwwwwwww", "내용":"ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ", "date":"yyyymmdd"}
router.post("/save",(req,res)=>{
    console.log("input| ",req.body);
    const data = req.body;
    const token = req.header('Authorization');
    let sql = "insert into tbl_diary (title,content,created_at,user_id) values ( ?,?,?,? );"
    conn.query(sql,[data.title, data.content, data.date,token],(err,rows)=>{
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
    console.log(req.body);
    const data = req.body;
    const token = req.header('Authorization');
    console.log(token);
    let sql = "select * from tbl_diary where created_at = ? and user_id =?;"
    conn.query(sql,[data.date,token],(err,rows)=>{
        console.log("rows | ",rows);    
        console.log("err  | ",err);
        console.log(rows.length);
        
        // console.log({"result":true, "title":rows[0].title,"content":rows[0].content});
        if (rows[0])   res.json({"result":true, "title":rows[0].title,"content":rows[0].content});
        else res.json({"result" : false});
        
    })
})

// 다이어리 수정
// 받은 데이터 형식
// {"title" : "WWWWWW" , "content": "dddddddd", "date": yyyymmdd, user_id : "EEEE"}
router.post("/change",(req,res)=>{
    console.log(req.body);
    const data = req.body;
    const token = req.header('Authorization');
    let sql = "update tbl_diary set title=?, content=? where created_at = ? and user_id =?;"
    conn.query(sql,[data.title, data.content, data.date,token],(err,rows)=>{
        console.log("rows | ",rows);
        console.log("err  | ",err);
        
        if (rows)   res.json({"result":true, "rows":rows});
        else res.json({"result" : false});
        ㅣ
    })
})

// 다이어리 삭제
// 받은 데이터 형식
// {"date": yyyymmdd, user_id : "EEEE"}
router.post("/del",(req,res)=>{
    console.log(req.body);
    const data = req.body;
    const token = req.header('Authorization');
    let sql = "delete from tbl_diary where created_at = ? and user_id =?;"
    conn.query(sql,[data.date,token],(err,rows)=>{
        console.log("rows | ",rows);
        console.log("err  | ",err);
        if (rows)   res.json({"result":true, "rows":rows});
        else res.json({"result" : false});
        
    })
})

router.post("/marker", (req, res) => {
    console.log(req.body);
    const token = req.header('Authorization');
    let sql = 'select created_at from tbl_diary where user_id = ?;'
    conn.query(sql, [token], (err, rows) => {
        console.log("rows | ",rows);
        console.log('err | ',err);
        if (rows)   res.json({"result":true, "rows":rows});
        else res.json({"result" : false});
    })
})

module.exports = router; 
>>>>>>> 9f08a3dd7014358283f1ab728450b64ac01e7eae:Node.js/router/diaryRouter.js
