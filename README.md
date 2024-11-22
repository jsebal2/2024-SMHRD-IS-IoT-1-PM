// get 방식
void getDio() async{
    final dio = Dio();
    Response res = await dio.get('http://192.168.219.61:8000',
        queryParameters: {'data' : 'DDDDDDDDDDDDDDD','send':'get'}
    );
    // 전송결과 출력
    print(res);
    if(res.statusCode == 200){
      print('dio | ${res}');
    }else{
      print('error 발생');
    }
  }
  // get 방식 끝


 // post 방식
  void postDio() async{
    final dio = Dio();
    // post 방식의 데이터 전달을 위한 option
    dio.options.contentType = Headers.formUrlEncodedContentType;
    Response res = await dio.post('http://192.168.219.61:8000/',
        data: {'data' : 'asdsad', 'send' : 'post'});

    // 전송결과 출력
    print(res);
    if(res.statusCode == 200){
      print('dio|${res}');
    } else {
      print('error 발생');
    }
  }
  // post 방식 끝




// 비동기방식을 위한 FutureBuilder
Future<String> getting = Future<String>.delayed(
Duration(seconds: 2),
() => 'Data Loaded',
);

getting.then((value) => handleValue(value))
.catchError((error) => handleError(error));

try{
String a = await getting();
handleVlaue(value);
} catch(error){
handleError(error);
}