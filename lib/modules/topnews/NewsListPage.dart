// 新闻列表页

import 'package:flutter/material.dart';

class NewsListPage extends StatefulWidget {
  
  
  
  @override
  State<StatefulWidget> createState() {
    return new NewsState();
  }
  
}


class NewsState extends State<NewsListPage> {
  
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Text("需要获取从tab传递的code"),
    );
  }
  
}