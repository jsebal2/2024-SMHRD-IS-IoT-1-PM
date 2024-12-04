const express = require("express");
const app = express();
const bodyParser = require('body-parser');
const cors = require("cors");

const PORT = 8000;

app.use(express.static("public"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true })); // URL-encoded 형식의 요청 본문 파싱



app.use(cors({
        origin : ['http://localhost:3000',],
        methods : ['GET','POST'],
        // cookies를 통한 통신
        credentials : true,
        exposedHeaders: ["Authorization"],
}
));



const mainRouter = require("./router/mainRouter.js") ;
const userRouter = require("./router/userRouter.js");
const sensorRouter = require('./router/sensorRouter.js');
const picRouter = require("./router/picRouter.js");
const diaryRouter = require("./router/diaryRouter.js");
const plantRouter = require("./router/plantRouter.js")
app.use('/',mainRouter);
app.use('/user',userRouter);
app.use('/sensor',sensorRouter);
app.use('/pic',picRouter);
app.use('/diary',diaryRouter);
app.use('/plant',plantRouter);



app.listen(PORT, () => {
    console.log(`Listening on port ${PORT}...`);
}); 