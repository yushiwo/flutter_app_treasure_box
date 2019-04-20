import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';

/// 手机归属地（两个section：一部分由输入框和查询按钮组成；另一部分由查询结果（手机号码、省份、城市、运营商）组成）
class PhoneAreaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("手机号码归属地"),
      ),
      body: _buildPageView(context),
    );
  }

  Widget _buildPageView(BuildContext context) {
    return new Column(
      children: <Widget>[
        // 查询部分
        _buildQueryView(context),

        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        ),

        // 结果部分
        _buildResultView(context)
      ],
    );
  }


  Widget _buildQueryView(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,

      child: new Card(
        child: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            children: <Widget>[
              // 输入框
              new TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: "请输入手机号码"
                ),
                onChanged: (text){
                  Util.showToast(text);
                },
              ),

              new Padding(padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),),

              // 查询按钮
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                        child: new Text("查询"),
                        onPressed: () {
                          Util.showToast("查询");
                        }),
                  )

                ],
              )


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      child: new Card(
        child: new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              // 手机号
              new Row(
                children: <Widget>[
                  new Expanded(child: new Text("手机号：13186970952", textAlign: TextAlign.left),)
                ],
              ),

              new Divider(),

              // 运营商
              new Row(
                children: <Widget>[
                  new Expanded(child: new Text("手机号：13186970952", textAlign: TextAlign.left),)
                ],
              ),

              new Divider(),

              // 省份
              new Row(
                children: <Widget>[
                  new Expanded(child: new Text("手机号：13186970952", textAlign: TextAlign.left),)
                ],
              ),

              new Divider(),

              // 城市
              new Row(
                children: <Widget>[
                  new Expanded(child: new Text("手机号：13186970952", textAlign: TextAlign.left),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}