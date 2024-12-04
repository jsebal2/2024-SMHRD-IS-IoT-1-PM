const express = require("express");
const router = express.Router();
const conn = require("../config/db");

router.post("/enroll",(req,res)=>{
    console.log(req.body);
    let {name,nick,id} = req.body


    let sql = "insert into tbl_pot(plant_name,plant_nick, created_at,user_id) values (?,?,NOW(),?)"

    conn.query(sql,[name,nick,id],(err,rows)=>{
        console.log("rows",rows)
        if (rows){
            res.status(200).json({"result":true});
        }else{
            res.status(400).json({"result":false,
                                    error : err})
            console.log(err);
        }
    });
})

router.post("/isthere",(req,res)=>{
    console.log(req.body);
    let {id} = req.body
    let sql = 'select * from tbl_pot where user_id=?'
    conn.query(sql,[id],(err,rows)=>{
        console.log('row',rows[0]);
        console.log('err',err);
        if (rows[0]){
            // 토큰 
            res.json({"result":true,  "select":rows[0]})                        
        }else{
            res.status(500).json(({"result":false,error:err}));
        }
    })
})



module.exports = router;
