import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:phonebook/personVo.dart';
import 'personVo.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("리스트페이지"),),

      body: Container(
          padding: EdgeInsets.all(15),
          color: Color(0xffd6d6d6),
          child: _ListPage()
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, "/write");
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }
}

class _ListPage extends StatefulWidget {
  const _ListPage({super.key});

  @override
  State<_ListPage> createState() => _ListPageState();
}


//할일
class _ListPageState extends State<_ListPage> {

  //공통변수
  late Future<List<PersonVo>> personListFuture;

  //생애주기별 훅

  //초기화할때
  @override
  void initState() {
    super.initState();
    personListFuture = getPersonList();
  }

  //그림 그릴때
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: personListFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는 데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else { //데이터가 있으면
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  Container(
                      width: 50,
                      height: 40,
                      color: Color(0xff00ffff),
                      alignment: Alignment.centerLeft,
                      child: Text("${snapshot.data![index].personId}",style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                      width: 120,
                      height: 40,
                      color: Color(0xff00ffff),
                      alignment: Alignment.centerLeft,
                      child: Text("${snapshot.data![index].name}",style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                      width: 170,
                      height: 40,
                      color: Color(0xff00ffff),
                      alignment: Alignment.centerLeft,
                      child: Text("${snapshot.data![index].hp}",style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                      width: 150,
                      height: 40,
                      color: Color(0xff00ffff),
                      alignment: Alignment.centerLeft,
                      child: Text("${snapshot.data![index].company}",style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    color: Color(0xff00ffff),
                    child: IconButton(
                        onPressed: () {
                          print("${snapshot.data![index].personId}");
                          Navigator.pushNamed( context, "/read",
                            arguments: {
                              "personId": snapshot.data![index].personId
                            }
                          );
                        },
                        icon: Icon(Icons.subdirectory_arrow_left)
                    ),
                  ),

                ],
              );
            },
          );

        } // 데이터가있으면
      },
    );

  }

  //리스트 가져오기
  Future<List<PersonVo>> getPersonList() async {
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://43.200.177.184:9999/api/phonebooks',
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
        print(response.data[2]["name"]); // json->map 자동변경

        List<PersonVo> personList = [];
        for(int i=0;i<response.data.length;i++){
          PersonVo personVo = PersonVo.fromJson(response.data[i]);
          personList.add(personVo);
        }
        print(personList);


        return personList;
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }//getPersonList()

}
