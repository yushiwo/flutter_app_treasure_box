import 'dart:async';

import 'package:easy_alert/easy_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_treasure_box/modules/global/util/Util.dart';
import 'package:simple_permissions/simple_permissions.dart';

class FlashManagePage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return new FlashState();
  }
}

class FlashState extends State<FlashManagePage> {

  static const platform = const MethodChannel('flutter.io/flash');

  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void deactivate() {
    turnOffFlash();
    super.deactivate();
  }

  @override
  void dispose() {
    turnOffFlash();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("手电筒"),
      ),

      body: new Center(
        child: initFlashSwitchButton(),
      ),
    );
  }

  Widget initFlashSwitchButton() {
    return new InkWell(
      child: new Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue
        ),

        child: getFlashIcon(),
      ),

      onTap: () {
        // 控制开关的状态
        if(isOpen) {
          turnOffFlash();
        } else {
          turnOnFlash();
        }
      },
    );
  }

  // 获取闪光灯开关icon（开 or 关）
  Widget getFlashIcon() {
    if(isOpen) {
      return new Icon(Icons.flash_on, color: Colors.white);
    } else {
      return new Icon(Icons.flash_off, color: Colors.white);
    }
  }

  Future<Null> turnOnFlash() async {
    setState(() {
      isOpen = true;
    });
    await platform.invokeMethod('turnOnFlash');
  }

  Future<Null> turnOffFlash() async {
    setState(() {
      isOpen = false;
    });

    await platform.invokeMethod('turnOffFlash');
  }

  void _checkPermission() async {
    bool hasPermission = await SimplePermissions.checkPermission(Permission.Camera);
    if (!hasPermission) {
      var requestPermissionResult = (await SimplePermissions.requestPermission(Permission.Camera));
//      if (!requestPermissionResult) {
//        Alert.alert(context, title: "申请相机权限失败");
//        return;
//      }
    }

  }

}
