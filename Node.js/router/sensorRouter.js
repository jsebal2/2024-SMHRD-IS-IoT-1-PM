const express = require("express");
const router = express.Router();
const spawn = require("child_process").spawn;

// 센서 데이터 요청 <= 변경 요청 {"senser":"light","state":"true"} 형식
// { '조명': 'true' }
// { '팬': 'true' }
// { '펌프': 'true' }
router.get("/act",(req,res)=>{
    jsonToSend = {}
    console.log(req.query);
    // 엑츄레이터 작동
    const act = spawn('python',["../Jetson/actu.py"]);
    // C:\Users\smhrd\Desktop\실전프로젝트\code\Jetson\sensor.py
        act.stdout.on('data',(getdata)=>{
            data2Str = getdata.toString('utf8');
            console.log(data2Str);
            // client로 보내줄 정보 추가
            jsonToSend["result"] = true;
            jsonToSend["data"] = data2Str
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
            return;
        })
    })
    
})
router.get("/sen",(req,res)=>{
    console.log("SSSSSSSSSS")
    console.log(req.query)
    jsonToSend = {}
    // 센서값 보내주기
    const sen = spawn('python',["../Jetson/sensor.py"]);
    // 성공했을 경우, dataSend는 출력 결과물
    sen.stdout.on('data',(dataSend)=>{
        data2Str = JSON.parse(dataSend.toString('utf8'));

        
        //클라이언트로 보내줄 jsonToSend의 속성을 추가해준다.
        //stdout.on이 실행됐다는 것은 의도한대로 진행이 된 것이므로 success에 true를,
        //data항목에 받아온 출력결과물을 담아준다.
        jsonToSend["result"] = true;
        jsonToSend["data"] = data2Str;
    })
    // 에러발생
    sen.stderr.on("data",(err)=>{
        console.log(err.toString())
        jsonToSend["result"] = false;
        jsonToSend["err_code"] = -1;
        jsonToSend["err_msg"] = "불러오기에 실패했습니다. 다시 시도해주세요!";
        jsonToSend["err_content"] = err.toString("utf8");
    })
    // process 종료
    sen.on("close",(code)=>{
        if (code != 0){
            console.log(`child process close all stdio with code ${code}`);
        }
        // 이제 출력결과 보냄 ( code가  0 이면 )
        res.json(jsonToSend);
    })
})



module.exports = router;
