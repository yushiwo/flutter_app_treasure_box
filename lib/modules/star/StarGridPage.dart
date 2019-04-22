import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';
import 'package:flutter_app_treasure_box/modules/star/StarDetailPage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StarGridPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StarState();
  }
}

class StarState extends State<StarGridPage> {

  List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
    const StaggeredTile.count(1, 2),
  ];

  List<Widget> _tiles = const <Widget>[
    const _Example01Tile(Colors.green, Icons.stars, "白羊座"),
    const _Example01Tile(Colors.lightBlue, Icons.stars, "金牛座"),
    const _Example01Tile(Colors.amber, Icons.stars, "双子座"),
    const _Example01Tile(Colors.brown, Icons.stars, "巨蟹座"),
    const _Example01Tile(Colors.deepOrange, Icons.stars, "狮子座"),
    const _Example01Tile(Colors.indigo, Icons.stars, "处女座"),
    const _Example01Tile(Colors.red, Icons.stars, "天秤座"),
    const _Example01Tile(Colors.blue, Icons.stars, "天蝎座"),
    const _Example01Tile(Colors.cyan, Icons.stars, "射手座"),
    const _Example01Tile(Colors.pinkAccent, Icons.stars, "摩羯座"),
    const _Example01Tile(Colors.yellow, Icons.stars, "水平座"),
    const _Example01Tile(Colors.purple, Icons.stars, "双鱼座"),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("星座运势"),
      ),

      body: new Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: new StaggeredGridView.count(
            crossAxisCount: 3,
            staggeredTiles: _staggeredTiles,
            children: _tiles,
            mainAxisSpacing: 3.0,
            crossAxisSpacing: 3.0,
            padding: const EdgeInsets.all(4.0),
          ))
    );
  }

}

class _Example01Tile extends StatelessWidget {
  const _Example01Tile(this.backgroundColor, this.iconData, this.iconName);

  final Color backgroundColor;
  final IconData iconData;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new StarDetailPage(iconName)));
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