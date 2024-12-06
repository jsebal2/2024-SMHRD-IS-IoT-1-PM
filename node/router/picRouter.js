const express = require("express");
const router = express.Router();
// const path = require("path");
// const fs = require("fs");
const conn = require("../config/db");

// 이미지 주기
router.get("/pull", async (req,res)=>{
    console.log(req.query);
    [file_name,file_ext] = req.query;
    // {"file_name":
    //   "file_ext": }
    let sql = "INSERT INTO tbl_file (file_rname, file_ext, uploaded_at) VALUES(?,?,NOW())"
    conn.query(sql,[file_name,file_ext],(err,rows)=>{
        console.log(rows);
        console.log(err);
        if (rows){
            const imageURL = `https://storage.googleapis.com/plant_mate_pic/${file_name}.${file_ext}`
            res.status(200).json({"img_url": imageURL})
        }else{
            res.status(404).json({  
                                    "result":false,
                                    "error":err
                                })
        }        
    })
    // const img = fs.readFileSync('./public/pic1.png');
    // res.writeHead(200, {"Context-Type":"image/png"});
    // res.write(img);
    // res.end();
    // or
    // res.sendFile(path.join(__dirname,'../public/pic1.png'))
    // res.json({"eee":"EEE"})
});
module.exports = router;
