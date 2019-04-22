import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

/// 最新笑话，需要支持分页加载
class JokeListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new JokeState();
  }
}

class JokeState extends State<JokeListPage> {
  final String _url = 'http://v.juhe.cn/joke/content/text.php?';
  final String _key = '4fe744555babd36b877ca6f35e5950c0';

  int currentPageIndex = 1;
  bool isLoadingMore = false;

  List<dynamic> items = new List();

  ScrollController _scrollController = new ScrollController();


  Future<String> get(int page) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse('${_url}&page=${page}&key=$_key'));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }


  Future<Null> refreshData() async{
    currentPageIndex = 1;
    Future<String> requestStr = get(currentPageIndex);   //注意await关键字

    requestStr?.then((String resultStr) {
      List<dynamic> values = jsonDecode(resultStr)['result']!=null ? jsonDecode(resultStr)['result']['data']:[''];
      setState(() {
        items.clear();
        print("values = " + values.toString());
        print("values length = " + values.length.toString());
        items.addAll(values);
        return null;
      });
    });

  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      print('refresh');
      setState(() {
        items.clear();
        items = List.generate(40, (i) => i);
        return null;
      });
    });
  }

  Future _getMoreData() async {
    if (!isLoadingMore) {
      setState(() => isLoadingMore = true);
      currentPageIndex = currentPageIndex + 1;
      Future<String> requestStr = get(currentPageIndex);
      requestStr?.then((String resultStr) {
        List<dynamic> values = jsonDecode(resultStr)['result']!=null ? jsonDecode(resultStr)['result']['data']:[''];
        setState(() {
          print("values = " + values.toString());
          print("values length = " + values.length.toString());
          items.addAll(values);
          isLoadingMore = false;
          return null;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    refreshData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("loadMore");
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("最新笑话"),
      ),
      body: new RefreshIndicator(
        child: new Padding(
          padding: EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return _buildProgressIndicator();
              } else {
                return _newsRow(context, items[index]["content"], items[index]["updatetime"]);
              }
            },
            controller: _scrollController,
          ),
        ),
        onRefresh: refreshData,
      ),
    );
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


  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoadingMore ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }
}
