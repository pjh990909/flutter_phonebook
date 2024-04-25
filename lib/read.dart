import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personVo.dart';

class Ex01 extends StatelessWidget {
  const Ex01({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("읽기페이지"),
      ),
      body: _ReadPage(),

    );
  }
}
//상태 변화를 감시하게 등록시키는 클래스
class _ReadPage extends StatefulWidget {
  const _ReadPage({super.key});

  @override
  State<_ReadPage> createState() => _ReadPageState();
}
//할일 정의 클래스(통신, 데이터적용)
class _ReadPageState extends State<_ReadPage> {

  //변수
  late Future<PersonVo> personVoFuture;

  //초기화함수 (1번만 실행됨)
  @override
  void initState() {
    super.initState();
    //추가코드 //데이터불러오기 메소드호출
    print("initStage(): 데이터 가져오기 전");

    personVoFuture = getPersonByNo();

    print("initStage(): 데이터 가져오기 후");
  }

  //화면 그리기
  @override
  Widget build(BuildContext context) {
    print("build(): 그리기 작업");
    return FutureBuilder(
      future: personVoFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else { //데이터가 있으면
          
          return Container(
            child: Container(
                color: Color(0xf0d5d5d5),
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 50,
                          color: Color(0xf0ffffff),
                          alignment: Alignment.centerLeft,
                          child: Text("번호",style: TextStyle(fontSize: 20),),
                        ),
                        Container(
                            width: 350,
                            height: 50,
                            color: Color(0xf0ffffff),
                            alignment: Alignment.centerLeft,
                            child: Text("${snapshot.data!.personId}",style: TextStyle(fontSize: 20),)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 50,
                          color: Color(0xf0ffffff),
                          alignment: Alignment.centerLeft,
                          child: Text("이름",style: TextStyle(fontSize: 20),),
                        ),
                        Container(
                            width: 350,
                            height: 50,
                            color: Color(0xf0ffffff),
                            alignment: Alignment.centerLeft,
                            child: Text("${snapshot.data!.name}",style: TextStyle(fontSize: 20),)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 50,
                          color: Color(0xf0ffffff),
                          alignment: Alignment.centerLeft,
                          child: Text("핸드폰",style: TextStyle(fontSize: 20),),
                        ),
                        Container(
                            width: 350,
                            height: 50,
                            color: Color(0xf0ffffff),
                            alignment: Alignment.centerLeft,
                            child: Text("${snapshot.data!.hp}",style: TextStyle(fontSize: 20),)
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 50,
                          color: Color(0xf0ffffff),
                          alignment: Alignment.centerLeft,
                          child: Text("회사",style: TextStyle(fontSize: 20),),
                        ),
                        Container(
                            width: 350,
                            height: 50,
                            color: Color(0xf0ffffff),
                            alignment: Alignment.centerLeft,
                            child: Text("${snapshot.data!.company}",style: TextStyle(fontSize: 20),)
                        ),
                      ],
                    ),
                  ],
                )
            ),
          );
        } // 데이터가있으면
      },
    );

  }

  //3번(정우성) 데이타 가져오기
  Future<PersonVo> getPersonByNo() async{
    print("getPersonByNo(): 데이터 가져오기 중");
    //코드 작성
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://43.200.177.184:9999/api/phonebooks/4',
        /*
        queryParameters: {
          // 예시 파라미터
          'page': 1,
          'keyword': '홍길동',
        },
        data: {
          // 예시 data  map->json자동변경
          'id': 'aaa',
          'pw': '값',
        },
        */
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data);// json->map 자동변경

        return PersonVo.fromJson(response.data);
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }

  }
}
