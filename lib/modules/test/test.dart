import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_app_treasure_box/modules/global/model/phone_area_model.dart';
import 'package:flutter_app_treasure_box/modules/global/model/test_model.dart';
class Test {
  static Future<String> _loadShapeJson() async {
    return await rootBundle.loadString('assets/shape.json');
  }

  static Future<Shape> decodeShape() async {
    String shapeJson = await _loadShapeJson();

    Map<String, dynamic> jsonMap = json.decode(shapeJson);

    print("shapeJson = " + shapeJson);
    Shape shape = Shape.fromJson(jsonMap);

    print('shape name is ${shape.name}');
    return shape;
  }


  static Future<String> _loadAreaJson() async {
    return await rootBundle.loadString('assets/area.json');
  }

  static Future<PhoneAreaDto> decodeArea() async {
    String areaJson = await _loadAreaJson();

    Map<String, dynamic> jsonMap = json.decode(areaJson);

    PhoneAreaDto phoneAreaDto = PhoneAreaDto.fromJson(jsonMap);

    print('reason is ${phoneAreaDto.reason}');
    return phoneAreaDto;
  }
}