const express = require("express");
const router = express.Router();

router.get("/",(req,res)=>{
    console.log(req.query);
    console.log(`받은거 : ${req.query.send}`)
    res.json({
        "온도":"2w",
        "습도":"3w",
        "조도" : "4w"
    })
})

router.post("/",(req,res)=>{
    console.log(req.body);
    console.log(`받은거 : ${req.body.send}`)
    res.json({
        "온도":"ㅍㅍㅍㅍㅍㅍ",
        "습도":"ㅇㅇㅇㅇㅇㅇㅇ",
        "조도" : "ㄴㄴㄴㄴㄴㄴㄴ"
    })
})



module.exports = router;
