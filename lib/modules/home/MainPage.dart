import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/routes.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/*
* 首页，九宫格显示各个免费小工具（用ListView实现，支持滑动）
*/
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: new StaggeredGridView.count(
          crossAxisCount: 4,
          staggeredTiles: _staggeredTiles,
          children: _tiles,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
        ));
  }
  
}


List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 2),
  const StaggeredTile.count(2, 2),
];

List<Widget> _tiles = const <Widget>[
  const _Example01Tile(Colors.green, Icons.highlight, "手电筒", flashRoute),
  const _Example01Tile(Colors.lightBlue, Icons.wifi, "附近Wi-Fi", wifiRoute),
  const _Example01Tile(Colors.amber, Icons.phone_android, "手机号码归属地", phoneRoute),
  const _Example01Tile(Colors.brown, Icons.library_books, "新闻头条", topNewsRoute),
  const _Example01Tile(Colors.deepOrange, Icons.history, "历史上的今天", historyRoute),
  const _Example01Tile(Colors.indigo, Icons.child_care, "笑话", jokeRoute),
];

class _Example01Tile extends StatelessWidget {
  const _Example01Tile(this.backgroundColor, this.iconData, this.iconName, this.routePath);

  final Color backgroundColor;
  final IconData iconData;
  final String iconName;
  final String routePath;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(routePath);
        },
        child: new Center(
          child: new Padding(
            padding: const EdgeInsets.all(4.0),
            child: new Center(
              child: new Container(
                child: getItemContentView(),
              ),
            )
          ),
        ),
      ),
    );
  }

  Widget getItemContentView() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Icon(
          iconData,
          color: Colors.white,
        ),
        new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 0.0),
          child: new Text(
              iconName,
              style: new TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}