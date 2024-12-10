const express = require("express");
const router = express.Router();
const spawn = require("child_process").spawn;
const path = require("path");

router.get("/",(req,res)=>{
    console.log(req.query);
    let jsonToSend = {}

    const act = spawn('python',[path.join('../Jetson/actu.py'),"something",'{"time":20,"persent":30}']);
        act.stdout.on('data',(getdata)=>{
            console.log("SSSSSSSSSSSSSSSSSSSSSS");
            data2Str = getdata.toString('utf8');
            console.log(data2Str);
            // client로 보내줄 정보 추가
            jsonToSend["result"] = true;
            jsonToSend["data"] = data2Str
        })
        // 에러발생
        act.stderr.on("data",(err)=>{
            console.log(err.toString())
            jsonToSend["result"] = false;
            jsonToSend["err_code"] = -1;
            jsonToSend["err_msg"] = "불러오기에 실패했습니다. 다시 시도해주세요!";
            jsonToSend["err_content"] = err.toString("utf8");
            return;
        })
        // process 종료
        act.on("close",(code)=>{
            if (code != 0){
                console.log(`child process close all stdio with code ${code}`);
            }
            // 이제 출력결과 보냄 ( code가  0 이면 )
            res.json(jsonToSend);
            console.log(jsonToSend);
            
            return;
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
