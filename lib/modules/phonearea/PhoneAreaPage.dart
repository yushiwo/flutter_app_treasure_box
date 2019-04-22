import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/model/phone_area_model.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';
import 'package:flutter_app_treasure_box/modules/global/widget/ProgressDialog.dart';
import 'package:dio/dio.dart';

/// 手机归属地（两个section：一部分由输入框和查询按钮组成；另一部分由查询结果（手机号码、省份、城市、运营商）组成）
class PhoneAreaPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new PhoneAreaState();
  }
}

class PhoneAreaState extends State<PhoneAreaPage> {

  bool isQueryButtonDisable; // 查询按钮是否可点击
  bool _loading = false;    // 是否loading

  String inputContent;

  final String _url = 'http://apis.juhe.cn/mobile/get?';

  PhoneArea phoneArea;    // 手机号码归属地model

  @override
  void initState() {
    super.initState();
    this.isQueryButtonDisable = true;
  }

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
    return new ProgressDialog (
      loading: _loading,
      msg: '正在加载...',
      child: new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new Column(
            children: <Widget>[
              // 查询部分
              _buildQueryView(context),

              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              ),

              // 结果部分
              _buildResultView(context)
            ],
          ),
        )
    );
  }

  //HTTP请求的函数返回值为异步控件Future
  Future<PhoneAreaDto> _onQuery(String phoneNumber) async {
    setState(() {
      _loading = !_loading;
    });

    Response response;
    Dio dio = new Dio();
    response = await dio.get(_url, queryParameters: {"phone": phoneNumber, "key": "f1d3261a5c2b1926ec9067f8a03f0932"});
    print(response.data.toString());

    if(response.data['resultcode'] != "200") {
      Util.showToast(response.data['reason']);
      return null;
    } else {
      // 转化为model
      var phoneAreaDto = new PhoneAreaDto.fromJson(response.data);
      return phoneAreaDto;
    }
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
                maxLength: 13,
                maxLines: 1,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: "请输入手机号码",
                  prefixIcon: Icon(Icons.phone_android)
                ),
                onChanged: (text){
                  this.inputContent = text;
                  if(null != text) {
                    setState(() {
                      this.isQueryButtonDisable = false;
                    });
                  } else {
                    setState(() {
                      this.isQueryButtonDisable = true;
                    });
                  }
                },
              ),

              new Padding(padding: new EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),),

              // 查询按钮
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new RaisedButton(
                        child: new Text("查询", style: new TextStyle(fontSize: 16.0),),
                        color: Colors.blue,
                        highlightColor: Colors.blue[700],
                        disabledColor: Colors.grey,
                        shape: StadiumBorder(),
                        onPressed: getQueryButtonListener()
                    ),
                  )

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Function getQueryButtonListener() {
    if(this.isQueryButtonDisable) {
      return null;
    } else {
      return () {
        if(null == inputContent) {
          Util.showToast("手机号码不能为空");
        } else {
          Future<PhoneAreaDto> responseDto = _onQuery(this.inputContent);
          responseDto.then((PhoneAreaDto responseResult){
            setState(() {
              _loading = !_loading;
              if(responseResult != null) {
                phoneArea = responseResult?.result;
                Util.showToast("查询完成");
              }

            });
          });

        }

      };
    }
  }

  Widget _buildResultView(BuildContext context) {
    if(this.phoneArea == null) {
      return new Container(
        width: 0.0,
        height: 0.0,
      );
    } else {
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
                    new Expanded(child: new Text("手机号：${this.inputContent}", textAlign: TextAlign.left),)
                  ],
                ),

                new Divider(),

                // 运营商
                new Row(
                  children: <Widget>[
                    new Expanded(child: new Text("手机号：${this.phoneArea?.company}", textAlign: TextAlign.left),)
                  ],
                ),

                new Divider(),

                // 省份
                new Row(
                  children: <Widget>[
                    new Expanded(child: new Text("手机号：${this.phoneArea?.province}", textAlign: TextAlign.left),)
                  ],
                ),

                new Divider(),

                // 城市
                new Row(
                  children: <Widget>[
                    new Expanded(child: new Text("手机号：${this.phoneArea?.city}", textAlign: TextAlign.left),)
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

  }

}