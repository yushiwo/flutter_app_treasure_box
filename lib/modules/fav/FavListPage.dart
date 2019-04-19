
import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/detail/WifiDetailPage.dart';
import 'package:flutter_app_treasure_box/modules/global/model/wifi_model.dart';

class FavListPage extends StatefulWidget {
  @override
  FavListState createState() {
    return new FavListState();
  }
}

class FavListState extends State<FavListPage> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  List wifis = new List();

  Future<Null> loadData() async{
    var db = new WifiDatabaseHelper();
    wifis = await db.getAllNotes();   //注意await关键字
    if (!mounted) return; //异步处理，防止报错
    setState(() {});//什么都不做，只为触发RefreshIndicator的子控件刷新
  }

  Future<List> getFavWifis() {
    var db = new WifiDatabaseHelper();
    return db.getAllNotes();
  }

  Future<int> deleteWifi(Wifi wifi) {
    var db = new WifiDatabaseHelper();
    return db.deleteNote(wifi.id);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("收藏列表"),
      ),
      body: new FutureBuilder<List>(
        future: getFavWifis(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          return snapshot.hasData
              ? createListView(context, data)
              : new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }



  Widget createListView(BuildContext context, List wifis){
    List values = wifis;
    switch (values.length) {
      case 0:   //没有获取到数据，则返回请求失败的原因
        return new Center(
          child: new Card(
            child: new Text("当前没有收藏哦～"),
          ),
        );
      default:
        return  new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: values == null ? 0 : values.length,
            itemBuilder: (context, i) {
              return _newsRow(values[i]);
            }
        );
    }
  }

  Widget _newsRow(Wifi wifi) {

    return new ListTile(
      title: new Text(
        wifi.name,
        style: _biggerFont,
      ),
      onTap: (){  // 点击应该跳转详情页
        showDetailPage(wifi);
      },
    );
  }


  void showDetailPage(Wifi wifi) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new WifiDetailPage(wifi)));
  }


}