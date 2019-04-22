import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/model/topnews_model.dart';

/// 最新笑话，需要支持分页加载
class JokeListPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new JokeState();
  }

}


class JokeState extends State <JokeListPage> {

  final String _url = 'http://v.juhe.cn/joke/content/text.php?';
  final String _key = '4fe744555babd36b877ca6f35e5950c0';

  int currentPage = 1;

  //HTTP请求的函数返回值为异步控件Future
  Future<String> get(int page) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse('${_url}&page=${page}&key=$_key'));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

//  //HTTP请求的函数返回值为异步控件Future
//  Future<PhoneAreaDto> _onQuery(String phoneNumber) async {
//    setState(() {
//      _loading = !_loading;
//    });
//
//    Response response;
//    Dio dio = new Dio();
//    response = await dio.get(_url, queryParameters: {"phone": phoneNumber, "key": "f1d3261a5c2b1926ec9067f8a03f0932"});
//    print(response.data.toString());
//
//    if(response.data['resultcode'] != "200") {
//      Util.showToast(response.data['reason']);
//      return null;
//    } else {
//      // 转化为model
//      var phoneAreaDto = new PhoneAreaDto.fromJson(response.data);
//      return phoneAreaDto;
//    }
//  }

  Future<Null> loadData() async{
    await get(currentPage);   //注意await关键字
    if (!mounted) return; //异步处理，防止报错
    setState(() {});//什么都不做，只为触发RefreshIndicator的子控件刷新
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("最新笑话"),
      ),
      body: new RefreshIndicator(
        child: new FutureBuilder(   //用于懒加载的FutureBuilder对象
          future: get(currentPage),   //HTTP请求获取数据，将被AsyncSnapshot对象监视
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:        //get未执行时
              case ConnectionState.waiting:     //get正在执行时
                return new Center(
                  child: new Card(
                    child: new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new SizedBox(
                        width: 40.0,
                        height: 40.0,
                        child: new CircularProgressIndicator(  //在页面中央显示正在加载
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    )
                  ),
                ) ;
              default:
                if (snapshot.hasError)    //get执行完成但出现异常
                  return new Text('Error: ${snapshot.error}');
                else  //get正常执行完成
                  // 创建列表，列表数据来源于snapshot的返回值，而snapshot就是get(widget.newsType)执行完毕时的快照
                  // get(widget.newsType)执行完毕时的快照即函数最后的返回值。
                  return createListView(context, snapshot);
            }
          },
        ),
        onRefresh: loadData,
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot){
    List values;
    values = jsonDecode(snapshot.data)['result']!=null ? jsonDecode(snapshot.data)['result']['data']:[''];
    switch (values.length) {
      case 0:   //没有获取到数据，则返回请求失败的原因
        return new Center(
          child: new Card(
            child: new Text(jsonDecode(snapshot.data)['reason']),
          ),
        );
      default:
        return  new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: values == null ? 0 : values.length,
            itemBuilder: (context, i) {
              return _newsRow(context, values[i]["content"], values[i]["updatetime"]);
            }
        );
    }
  }

  Widget _newsRow(BuildContext mContext, String content, String updateTime) {
    return new Card(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // 笑话正文
            new Text(
              content,
              style: new TextStyle(fontSize: 16.0),
            ),

            new Padding(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0)),

            // 笑话更新时间
            new Row(
              children: <Widget>[
                new Expanded(
                  child: new Text(
                    updateTime,
                    style: new TextStyle(fontSize: 10.0, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            )


          ],
        ),
      )
    );
  }


}