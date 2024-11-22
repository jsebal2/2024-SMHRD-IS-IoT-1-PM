const express = require("express");
const router = express.Router();
const path = require("path");
const fs = require("fs");
// 이미지 주기
// router.get("/push",(req,res)=>{
    
// });

// 이미지 주기
router.get("/pull", async (req,res)=>{
    const img = fs.readFileSync('./public/pic1.png');
    res.writeHead(200, {"Context-Type":"image/png"});
    res.write(img);
    res.end();
    // or
    // res.sendFile(path.join(__dirname,'../public/pic1.png'))
    // res.json({"eee":"EEE"})
});
module.exports = router;
