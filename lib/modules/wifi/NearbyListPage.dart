import 'package:amap_location/amap_location.dart';
import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/detail/WifiDetailPage.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';
import 'package:simple_permissions/simple_permissions.dart';
import '../global/model/wifi_model.dart'; // 导入model
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class NearbyListPage extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<NearbyListPage> {
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  final String _url = 'http://apis.juhe.cn/wifi/local?';
  final double lon = 120.201798;
  final double lat = 30.257832;
  final int range = 3000;

  //HTTP请求的函数返回值为异步控件Future
  Future<String> get(double lon, double lat, int range) async {
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(
        '${_url}&lon=$lon&lat=$lat&r=$range&type=1&key=85e9b14aa37e5929e14d961f73a40367'));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async {
    await get(lon, lat, range); //注意await关键字
    if (!mounted) return; //异步处理，防止报错
    setState(() {}); //什么都不做，只为触发RefreshIndicator的子控件刷新
  }

//  void _checkPermission() async {
//    bool hasPermission =
//        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
//    if (!hasPermission) {
//      var requestPermissionResult = (await SimplePermissions.requestPermission(
//          Permission.WhenInUseLocation)) as bool;
//      if (!requestPermissionResult) {
//        Alert.alert(context, title: "申请定位权限失败");
//        return;
//      }
//    }
//
//    AMapLocationClient.startLocation();
//  }

  void _checkPersmission2() async {
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
    if (!hasPermission) {
//      bool requestPermissionResult = (await SimplePermissions.requestPermission(
//          Permission.WhenInUseLocation)) as bool;
//      if (!requestPermissionResult) {
//        Alert.alert(context, title: "申请定位权限失败");
//        return;
//      }
    }

        await AMapLocationClient.startup(new AMapLocationOption(
            desiredAccuracy: CLLocationAccuracy
                .kCLLocationAccuracyHundredMeters));
    AMapLocation location = await AMapLocationClient.getLocation(true);
    Util.showToast("111 = " + location.latitude.toString() + " : " + location.longitude.toString());

    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
      if (!mounted) return;
      setState(() {
        print("latitude = " + loc.latitude.toString());
        print("longitude = " + loc.longitude.toString());
        Util.showToast("222 = " + loc.latitude.toString() + " : " + loc.longitude.toString());
      });
    });

    AMapLocationClient.startLocation();
  }

  @override
  void initState() {
    super.initState();
    _checkPersmission2();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("附近的Wi-Fi"),
      ),
      body: new RefreshIndicator(
        child: new FutureBuilder(
          //用于懒加载的FutureBuilder对象
          future: get(lon, lat, range), //HTTP请求获取数据，将被AsyncSnapshot对象监视
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none: //get未执行时
              case ConnectionState.waiting: //get正在执行时
                return new Center(
                  child: new Card(
                    child: new SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: new CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    ), //在页面中央显示正在加载
                  ),
                );
              default:
                if (snapshot.hasError) //get执行完成但出现异常
                  return new Text('Error: ${snapshot.error}');
                else //get正常执行完成
                  // 创建列表，列表数据来源于snapshot的返回值，而snapshot就是get(widget.newsType)执行完毕时的快照
                  // get(widget.newsType)执行完毕时的快照即函数最后的返回值。
                  return createListView(context, snapshot);
            }
          },
        ),
        onRefresh: loadData,
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    // print(snapshot.data);
    List values;
    values = jsonDecode(snapshot.data)['result'] != null
        ? jsonDecode(snapshot.data)['result']['data']
        : [''];
    switch (values.length) {
      case 0: //没有获取到数据，则返回请求失败的原因
        return new Center(
          child: new Card(
            child: new Text(jsonDecode(snapshot.data)['reason']),
          ),
        );
      default:
        values.sort((a, b) => a["distance"].compareTo(b["distance"]));
        return new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: values == null ? 0 : values.length,
            itemBuilder: (context, i) {
              return _newsRow(new Wifi(
                  values[i]["name"],
                  values[i]["intro"],
                  values[i]["address"],
                  values[i]["google_lat"],
                  values[i]["google_lon"],
                  values[i]["baidu_lat"],
                  values[i]["baidu_lon"],
                  values[i]["lat"],
                  values[i]["lon"],
                  values[i]["distance"]));
            });
    }
  }

  Widget _newsRow(Wifi wifi) {
    return new Card(
      child: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new ListTile(
          title: new Text(
            wifi.name,
            style: _biggerFont,
          ),
          trailing: new Text(
            "${wifi.distance} m",
            style: _biggerFont,
          ),
          onTap: () {
            // 点击应该跳转详情页
            showDetailPage(wifi);
          },
        ),
      ),
    );
  }

  void showDetailPage(Wifi wifi) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new WifiDetailPage(wifi)));
  }
}
