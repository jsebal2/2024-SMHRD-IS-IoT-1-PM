const express = require("express");
const router = express.Router();
const conn = require("../config/db.js");
// const token = require('../functions/token.js');

// const input = {
//     'user_id' : id,
//     'user_pw' : pw,
//     'user_name' : username,
//     'created_at' : timestemp
// };

// 회원가입
router.post('/join',(req,res)=>{
    console.log(req.body);
    let {id,password,username} = req.body

    //2. db에 넣어주기
    // 2-1)sql문 작성
    let sql = "insert into tbl_user(user_id,user_pw,user_name, joined_at) values (?,SHA2(?,256),?,NOW())"
    // 2-2) 입력이 필요한 경우 값을 넣어주기
    // 2-3) conn.query 작성
    conn.query(sql,[id, password, username],(err,rows)=>{
        console.log("rows",rows)
        if (rows){
        // 회원가입(유저 생성), 글 작성 등 어떠한 리소스의 생성을 성공적으로 완료했을 때
        // 사용하는 Status Code로 일반적으로 POST 요청에서 많이 사용합니다.
            
            res.status(200).json({"result":true});
        }else{
            //주로 Query Parameter나 Request Body로 들어오는 데이터의 형식이 올바르지 않을 때와 같이 
            // 서버가 요청을 이해할 수 없는 상황에서 사용합니다.
            res.status(400).json({"result":false,
                                    error : err})
            console.log(err);
        }
    // res.status(201).json({message:"success"});
    });
})


// 로그인
router.post('/login',(req,res)=>{
    console.log(req.body);
    let {id,password} = req.body
    let sql = 'select * from tbl_user where user_id=? and user_pw=SHA2(?,256)'
    conn.query(sql,[id,password],(err,rows)=>{
        console.log('row',rows[0]);
        console.log('err',err);
        if (rows[0]){
            // 토큰 
            res.json({"result":true,  "token":rows[0].user_id})
            //  토큰 발급
            // accToken = token.createToken({'id': rows[0].user_id,
            //                             'email': rows[0].user_email},'acc');
            // refToken = token.createToken({'id': rows[0].user_id},'ref')
            // res.header('Authorization',newToken);
            // console.log("accToken : ",accToken );


            // status, 토큰, json 전송
            // res.status(200).cookie('refreshToken',refToken,{
            //     // expires:new Date(Date.now() + (60*30)),
            //     httpOnly: true,
            //     secure : false,
            //     // sameSite: "strict",
            // })
            // res.header('Authorization',accToken)
            // .json(({message:'success', info : rows}));
            // console.log("acc/ref토큰 보냄")
                        
        }else{
            res.status(500).json(({"result":false,error:err}));
        }
    })
    // res.status(404).json({massage: "login_success"});
})

// 탈퇴
router.post('/del',(req,res)=>{
    console.log(req.body);
    const {id,password} = req.body;
    let sql = "delete from tbl_user where user_id = ? and user_pw = SHA2(?,256)";
    conn.query(sql,[id,password],(err,rows)=>{
        console.log(rows);
        console.log(err);
        if (rows.affectedRows>0){
            res.json({"result":true});
        }else{
            res.json({"result":false});
        }
    })
})
// 수정
router.post("/change",(req,res)=>{
    console.log(req.body);
    const data = req.body;
    // username
    let sql = "update tbl_user set user_name = ? where user_id = ? and user_pw=SHA2(?,256)"
    // let sql = "select * from tbl_user where user_pw=SHA2(?,256)"
    conn.query(sql,[data.username, data.id, data.password],(err,rows)=>{
        console.log(rows)
        console.log(err);
        
        if (rows.affectedRows){
            res.json({"result":true})
        }else{
            res.json({"result":false});
        }
    })
    
})

router.post('/isthere', (req, res) => {
    console.log('유저라우터에서 보냄',req.body)
    const {id} = req.body
    let sql = 'select user_name from tbl_user where user_id = ?'
    conn.query(sql,[id], (err,rows) => {
        console.log(rows);

        if (rows.length > 0){
            res.json({"result":true, 'res':rows})
        }else{
            res.json({"result":false});
        }
        
    })
})
module.exports = router;