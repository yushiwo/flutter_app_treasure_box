import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/topnews/NewsListPage.dart';

class TopNewsMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TopNewsState();
  }
}

class TopNewsState extends State<TopNewsMainPage> with SingleTickerProviderStateMixin {
  
  final List<Tab> myTabs = [
    Tab(text: "头条",),
    Tab(text: "社会",),
    Tab(text: "国内",),
    Tab(text: "娱乐",),
    Tab(text: "体育",),
    Tab(text: "军事",),
    Tab(text: "科技",),
    Tab(text: "财经",),
    Tab(text: "时尚",),
  ];
  
  TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: myTabs.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("新闻头条"),
        bottom: new TabBar(
          isScrollable: true,
          tabs: myTabs,
          controller: _tabController,
        ),
      ),

      body: new TabBarView(
        controller: _tabController,
        children: myTabs.map((Tab tab) {
          return new Center(
            child: new NewsListPage(),
          );
        }).toList(),
      ),
    );
  }

}