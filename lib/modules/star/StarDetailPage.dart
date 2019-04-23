import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/model/star_model.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';
import 'package:flutter_app_treasure_box/modules/global/widget/ProgressDialog.dart';
import 'package:flutter_rating/flutter_rating.dart';

class StarDetailPage extends StatefulWidget {
  String consName;


  StarDetailPage(this.consName);

  @override
  State<StatefulWidget> createState() {
    return new StarDetailState(this.consName);
  }

}

class StarDetailState extends State<StarDetailPage> {

  StarDetail mStarDetail;
  String consName;

  bool _loading = false;    // 是否loading

  int starCount = 5;

  final String _url = 'http://web.juhe.cn:8080/constellation/getAll?';
  final String _key = 'e9c93b5f97574e261f60bf19e446c6e0';
  final String _type = 'today';

  StarDetailState(this.consName);

  @override
  void initState() {
    super.initState();
    Future<StarDetail> starDetail = _onQuery(consName, _type);
    starDetail.then((StarDetail result) {
      setState(() {
        mStarDetail = result;
        _loading = !_loading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("星座运势详情"),
      ),
      body: _buildPageView(context),
    );
  }

  Widget _buildPageView(BuildContext context) {
    return new ProgressDialog (
        loading: _loading,
        msg: '正在加载...',
        child: this.mStarDetail == null ? _showErrorPage() : _showResultPage()
    );
  }

  Widget _showErrorPage() {
    return new Center(
      child: Text("加载出错～"),
    );
  }

  Widget _showResultPage() {
    return new Container(
      color: Colors.blue,
      child: new Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: new Column(
            children: <Widget>[
              _buildSpace(24.0),
              _buildTitleView(context),
              _buildSpace(16.0),
              _buildMiddleView(),
              _buildSummaryView()
            ],
          )
        ),
      ),
    );
  }

  // 头部
  Widget _buildTitleView(BuildContext context) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(16.0),
        ),
        _buildStarView(context, Colors.blue, mStarDetail.name),
        new Padding(
          padding: EdgeInsets.all(16.0),
        ),
        _buildTitleContent(),
        new Padding(
          padding: EdgeInsets.all(16.0),
        ),
      ],
    );
  }

  Widget _buildStarView(BuildContext context, Color color, String text) {
    return new CircleAvatar(
      backgroundColor: color,
      radius: 50.0,
      child: new Text(
        text,
        style: new TextStyle(color: Colors.white, fontSize: 24.0),
      ),
    );
  }

  Widget _buildTitleContent() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(16.0),
        ),
        new Text(
          "今日运势(${Util.getMonthAndDay()})",
          style: new TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        new StarRating(
          size: 30.0,
          rating: Util.getRating(mStarDetail.all, starCount),
          color: Colors.orange,
          borderColor: Colors.grey,
          starCount: 5,
        ),
      ],
    );
  }

  Widget _buildMiddleView() {

    return new Column(

      children: <Widget>[
        new Row(
          children: <Widget>[
            new Expanded(
              child: _buildRatingItem("爱情指数：", Util.getRating(mStarDetail.love, starCount)),
            ),
            new Expanded(
              child: _buildRatingItem("健康指数：", Util.getRating(mStarDetail.health, starCount)),
            ),
          ],
        ),

        new Row(
          children: <Widget>[
            new Expanded(
              child: _buildRatingItem("财运指数：", Util.getRating(mStarDetail.money, starCount)),
            ),
            new Expanded(
              child: _buildRatingItem("工作指数：", Util.getRating(mStarDetail.work, starCount)),
            ),
          ],
        ),

        new Row(
          children: <Widget>[
            new Expanded(
              child: _buildInfoItem("幸运颜色：", mStarDetail.color),
            ),
            new Expanded(
              child: _buildInfoItem("幸运数字：", mStarDetail.number.toString()),
            ),
          ],
        ),

        new Row(
          children: <Widget>[
            new Expanded(
              child: _buildInfoItem("速配星座：", mStarDetail.QFriend),
            ),
          ],
        ),

      ],
    );

  }

  Widget _buildRatingItem(String ratingName, double ratingNum) {
    return new Row(
      children: <Widget>[
        _buildSpace(8.0),
        new Text(
          ratingName,
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        new StarRating(
          size: 15.0,
          rating: ratingNum,
          color: Colors.orange,
          borderColor: Colors.grey,
          starCount: 5,
        ),
      ],
    );
  }

  Widget _buildInfoItem(String infoName, String infoMessage) {
    return new Row(
      children: <Widget>[
        _buildSpace(8.0),
        new Text(
          infoName,
          style: TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        new Text(infoMessage, style: TextStyle(fontSize: 14.0),),
      ],
    );
  }

  Widget _buildSummaryView() {
    return new Padding(
      padding: EdgeInsets.all(16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text("今日概述", style: new TextStyle(fontSize: 16.0, color: Colors.blue, fontWeight: FontWeight.bold),),
          _buildSpace(4.0),
          new Text(
              mStarDetail.summary,
              style: new TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54
              )
          )

        ],
      ),
    );
  }

  Widget _buildSpace(double space) {
    return new Padding(
      padding: EdgeInsets.all(space),
    );
  }

  //HTTP请求的函数返回值为异步控件Future
  Future<StarDetail> _onQuery(String consName, String type) async {
    setState(() {
      _loading = !_loading;
    });

    Response response;
    Dio dio = new Dio();
    response = await dio.get(_url, queryParameters: {"consName": consName, "type": type, "key": _key});
    print(response.data.toString());

    Map<String, dynamic> reMap = json.decode(response.data);

    var starDetail = new StarDetail.fromJson(reMap);
    return starDetail;
  }

}