import 'package:amap_location/amap_location.dart';
import 'package:amap_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../global/model/wifi_model.dart'; // 导入model
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:easy_alert/easy_alert.dart';

// 标题栏：标题，收藏和取消收藏按钮
// wifi名称
// wifi详情信息
// 点击导航：toast提示待开发
//

class WifiDetailPage extends StatefulWidget {
  final Wifi wifi; //定义一个常量，用于保存跳转进来获取到的参数

  WifiDetailPage(this.wifi); //构造函数，获取参数

  @override
  _WifiDetailPageState createState() => _WifiDetailPageState();
}

class _WifiDetailPageState extends State<WifiDetailPage> {
  final String mUserName = "userName";

  var index = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Wifi详情"),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.favorite), onPressed: showToast),
        ],
      ),
      body: _refreshPage(widget.wifi),
    );
  }

  Widget _refreshPage(Wifi wifi) {
    return new Container(
      padding: const EdgeInsets.all(32.0),
      child: new Row(
        children: [
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 名字
                new Container(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: new Text(
                    wifi.name,
                    style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                new Container(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: new Text(
                    wifi.address,
                    style: new TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                // 导航和分享
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButtonColumn(Icons.near_me, '导航(待完成...)'),
                    buildButtonColumn(Icons.share, '分享(待完成...)'),
                  ],
                ),

                new Container(
                  padding: const EdgeInsets.only(top: 24.0),
                ),
                // 其它相关信息展示
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "其他信息",
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Text(
                      wifi.intro,
                      style: new TextStyle(
                        color: Colors.grey[500],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonColumn(IconData icon, String label) {
    Color color = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: showShortToast,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Icon(icon, color: color),
          new Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showShortToast() {
    index ++;
  }

  // 保存当前Wi-Fi信息到本地
  save() async {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((SharedPreferences preference) {
      preference.setString(mUserName, "123");
    });
  }

  Future<String> get() async {
    var userName;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString(mUserName);
    return userName;
  }

  Future _handleFavButtonClicked() async {
//    save();
//
//    Future<String> userName = get();
//    userName.then((String userName) {
//      print("数据获取成功：$userName");
//    });
//
//    Util.save(widget.wifi);
//
//    Future<List<Wifi>> favWifiList = Util.getFavWifiList();
//    favWifiList.then((List<Wifi> favWifiList){
//      print("我的收藏内容是： " + favWifiList.toString());
//    });
//
//    WifiProvider wifiProvider = new WifiProvider();
//    try {
//      Future<WifiProvider> p = wifiProvider.open();
//      p.then((WifiProvider pp) {
//        Future<Wifi> w1 = pp.insert(widget.wifi);
//        w1.then((Wifi wifi) {
//          print("111 = " + wifi.toString());
//        });
//
//        Future<List<Wifi>> w2 = pp.getAllWifis();
//        w2.then((List<Wifi> wifis) {
//          print("取出 = " + wifis.toString());
//        });
//      });
//    } catch (Exception) {}


//    _checkPermission();
//    await AMapLocationClient.startup(new AMapLocationOption(
//        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
//    AMapLocation location = await AMapLocationClient.getLocation(true);
//    print('定位有没有： ');
//    print("latitude = " + location.latitude.toString());
//    print("longitude = " + location.longitude.toString());
  }

  void _checkPermission() async {
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
    if (!hasPermission) {
      var requestPermissionResult = (await SimplePermissions.requestPermission(
          Permission.WhenInUseLocation)) as bool;
      if (!requestPermissionResult) {
        Alert.alert(context, title: "申请定位权限失败");
        return;
      }
    }

    AMapLocationClient.startLocation();
  }

  // 存储
  void handleSave() async {
    var db = new WifiDatabaseHelper();
    await db.saveNote(widget.wifi);
  }

  void handleDelete() async {
    var db = new WifiDatabaseHelper();
  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
