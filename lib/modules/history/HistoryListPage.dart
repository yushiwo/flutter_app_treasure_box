import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/model/history_model.dart';

class HistoryListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HistoryState();
  }
}

class HistoryState extends State<HistoryListPage> {
  final String _url = 'http://api.juheapi.com/japi/toh?';
  final String _key = '700ade3f476677be4916d514985e5ee4';
  final String _version = '2.0';

  List<dynamic> items = new List();

  Future<String> get(String month, String day) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(
        Uri.parse('${_url}&v=${_version}&key=$_key&month=$month&day=$day'));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<Null> refreshData() async {
    DateTime now = new DateTime.now();
    String month = now.month.toString();
    String day = now.day.toString();

    Future<String> requestStr = get(month, day); //注意await关键字

    requestStr?.then((String resultStr) {
      List<dynamic> values = jsonDecode(resultStr)['result'] != null
          ? jsonDecode(resultStr)['result']
          : [''];
      setState(() {
        items.clear();
        items.addAll(values);
        return null;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("历史上的今天"),
      ),
      body: new RefreshIndicator(
        onRefresh: refreshData,
        child: new Padding(
          padding: EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: this.items.length,
            itemBuilder: (context, index) {
              if (items.length <= 0) {
                return null;
              } else {
                return _newsRow(
                    context,
                    new History(
                        items[index]["_id"],
                        items[index]["title"],
                        items[index]["pic"],
                        items[index]["year"],
                        items[index]["month"],
                        items[index]["day"]));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _newsRow(BuildContext mContext, History history) {
    return new Card(
      child: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Row(
          children: <Widget>[
            // 图片
            _getThumbnail(history.pic),

            new Padding(padding: EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0)),

            // 标题 + 时间
            new Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // 标题
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          history.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      )
                    ],
                  ),

                  new Padding(padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0)),

                  // 时间
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                          "${history.year}/${history.month}/${history.day}",
                          textAlign: TextAlign.left,
                          style:
                              new TextStyle(fontSize: 10.0, color: Colors.grey),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getThumbnail(String picUrl) {
    if (picUrl == null || picUrl.trim().isEmpty) {
      return new SizedBox(
        width: 120,
        height: 80,
        child: new Image.asset(
          "images/pavlova.jpg",
          fit: BoxFit.fill,
        ),
      );
    } else {
      return new SizedBox(
        width: 120,
        height: 80,
        child: new Image.network(picUrl, fit: BoxFit.fill),
      );
    }
  }
}
