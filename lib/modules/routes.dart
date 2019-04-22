import 'package:flutter/material.dart';
import 'package:flutter_app_treasure_box/modules/flash/FlashManagePage.dart';
import 'package:flutter_app_treasure_box/modules/history/HistoryListPage.dart';
import 'package:flutter_app_treasure_box/modules/joke/JokeListPage.dart';
import 'package:flutter_app_treasure_box/modules/phonearea/PhoneAreaPage.dart';
import 'package:flutter_app_treasure_box/modules/star/StarGridPage.dart';
import 'package:flutter_app_treasure_box/modules/topnews/TopNewsMainPage.dart';
import 'package:flutter_app_treasure_box/modules/wifi/NearbyListPage.dart';


const String flashRoute = '/route_flash';
const String wifiRoute = '/route_wifi';
const String starRoute = '/route_star';
const String phoneRoute = '/route_phone';
const String topNewsRoute = '/route_top_news';
const String historyRoute = '/route_history';
const String jokeRoute = '/route_joke';


Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  flashRoute: (BuildContext context) =>
      new FlashManagePage(),
  wifiRoute: (BuildContext context) =>
      new NearbyListPage(),
  phoneRoute: (BuildContext context) =>
      new PhoneAreaPage(),
  topNewsRoute: (BuildContext context) =>
      new TopNewsMainPage(),
  historyRoute: (BuildContext context) =>
      new HistoryListPage(),
  jokeRoute: (BuildContext context) =>
      new JokeListPage(),
  starRoute: (BuildContext context) =>
  new StarGridPage(),
};
