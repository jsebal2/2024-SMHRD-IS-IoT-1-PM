const express = require("express");
const router = express.Router();
// const path = require("path");
// const fs = require("fs");
const conn = require("../config/db");

// 이미지 주기
router.get("/pull", async (req,res)=>{
    console.log(req.query);
    const {id,date} = req.query;
    // {"file_name":
    //   "file_ext": }
    let sql = 'select file_rname, file_ext from tbl_file where diary_idx =1 order by uploaded_at desc limit 1'
    conn.query(sql,[id,date],(err,rows)=>{
        console.log(rows);
        console.log(err);
        if (rows){
            const imageURL = `https://storage.googleapis.com/plant_mate_pic/${rows[0].file_rname}.${rows[0].file_ext}`
            res.status(200).send(imageURL)
        }else{
            res.status(404).json({  
                                    "result":false,
                                    "error":err
                                })
        }        
    })
    
});


router.post("/diary", async (req, res) => {
    const {id,date} = req.body
    let sql = 'select file_rname, file_ext from tbl_file where diary_idx =1 order by uploaded_at desc limit 1'
    conn.query(sql, [id,date], (err,rows) => {        
        console.log(rows);
        console.log(err);
        if (rows) {
            const imageURL = `https://storage.googleapis.com/plant_mate_pic/${rows[0].file_rname}.${rows[0].file_ext}`
            
            res.status(200).json({'img_url':imageURL})
        }else {
            res.status(404).json({  
                "result":false,
                "error":err
            })
        }  
    })
})
module.exports = router;

// const img = fs.readFileSync('./public/pic1.png');
    // res.writeHead(200, {"Context-Type":"image/png"});
    // res.write(img);
    // res.end();
    // or
    // res.sendFile(path.join(__dirname,'../public/pic1.png'))
    // res.json({"eee":"EEE"})
