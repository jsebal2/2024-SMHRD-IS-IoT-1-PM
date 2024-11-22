const express = require("express");
const app = express();
const bodyParser = require('body-parser');

const cors = require("cors");
const PORT = 8000;
// const cookieParser = require("cookie-parser");
app.use(express.static("public"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true })); // URL-encoded 형식의 요청 본문 파싱


//쿠키파서 등록하기
// app.use(cookieParser());
// //세션 등록
// app.use(session({
//     httpOnly : true,    //http로 접근한 요청만 처리
//     resave : false,     //세션을 항상 재저장할지 확인
//     secret : "secret",       //암호화할때 사용된 키값
//     store : new fileStore(),    //세션을 저장할 공간 할당
//     saveUninitialized : false    //세션이 비어있더라도 저장할거냐?
// }))
app.use(cors({
        origin : ['http://localhost:3000',],
        methods : ['GET','POST'],
        // cookies를 통한 통신
        credentials : true,
        exposedHeaders: ["Authorization"],
}
));

const mainRouter = require("./router/mainRouter.js");
const sensorRouter = require('./router/sensorRouter.js');
const picRouter = require("./router/picRouter.js");
const diaryRouter = require("./router/diaryRouter.js");
app.use('/',mainRouter);
app.use('/sensor',sensorRouter);
app.use('/pic',picRouter);
app.use('/diary',diaryRouter);



app.listen(PORT, () => {
    console.log(`Listening on port ${PORT}...`);
}); 