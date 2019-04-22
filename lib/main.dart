import 'package:flutter/material.dart';

import './modules/home/HomePage.dart';
import 'package:amap_location/amap_location.dart';

void main() {
  AMapLocationClient.setApiKey("e127b3de82eca3244bff5da394eace73");
  runApp(HomePage());
}


