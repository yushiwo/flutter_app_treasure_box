import 'package:flutter/material.dart';

import './modules/home/HomePage.dart';
import 'package:amap_location/amap_location.dart';

void main() {
  AMapLocationClient.setApiKey("eda660c45988fdf63dff2d7a13fa5ba6");
  runApp(HomePage());
}


