// 附近Wi-Fi的数据model

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = "fav_wifi_list";   // 收藏的wifi列表

final String columnId = '_id';
final String columnName = 'name';
final String columnIntro = 'intro';
final String columnAddress = 'address';
final String columnGoogleLat = 'google_lat';
final String columnGoogleLon = 'google_lon';
final String columnBaiduLat = 'baidu_lat';
final String columnBaiduLon = 'baidu_lon';
final String columnLat = 'lat';
final String columnLon = 'lon';
final String columnDistance = 'distance';
final String columnLocation = 'location';

class Wifi {
  String name;
  String intro;
  String address;
  String google_lat;
  String google_lon;
  String baidu_lat;
  String baidu_lon;
  String lat;
  String lon;
  int distance;
  int id;
  String location;

  Wifi(this.name, this.intro, this.address, this.google_lat, this.google_lon, this.baidu_lat, this.baidu_lon, this.lat, this.lon, this.distance) {
    id = null;
    name = this.name;
    intro = this.intro;
    address = this.address;
    google_lat = this.google_lat;
    google_lon = this.google_lon;
    baidu_lat = this.baidu_lat;
    baidu_lon = this.baidu_lon;
    lat = this.lat;
    lon = this.lon;
    distance = this.distance;
    if (this.google_lat == null || this.baidu_lat == null) {
      location = distance.toString();
    } else {
      location = "" + this.google_lat + this.baidu_lat;
    }

  }

  @override
  String toString() {
    return 'Wifi{name: $name, intro: $intro, address: $address, google_lat: $google_lat, google_lon: $google_lon, baidu_lat: $baidu_lat, baidu_lon: $baidu_lon, lat: $lat, lon: $lon, distance: $distance}';
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnName: name,
      columnIntro: intro,
      columnAddress: address,
      columnGoogleLat: google_lat,
      columnGoogleLon: google_lon,
      columnBaiduLat: baidu_lat,
      columnBaiduLon: baidu_lon,
      columnLat: lat,
      columnLon: lon,
      columnDistance: distance,
      columnLocation: google_lat + baidu_lat + lat
    };

    if(id != null) {
      map[columnId] = id;
    }
    
    return map;
  }

  Wifi.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    intro = map[columnIntro];
    address = map[columnAddress];
    google_lat = map[columnGoogleLat];
    google_lon = map[columnGoogleLon];
    baidu_lat = map[columnBaiduLat];
    baidu_lon = map[columnBaiduLon];
    lat = map[columnLat];
    lon = map[columnLon];
    distance = map[columnDistance];
    location = map[columnLocation];
  }

}

class WifiDatabaseHelper {
  static final WifiDatabaseHelper _instance = new WifiDatabaseHelper.internal();

  factory WifiDatabaseHelper() => _instance;

  static Database _db;

  WifiDatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');

    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        '''
        CREATE TABLE $tableName(
        $columnId integer primary key autoincrement, 
        $columnName text not null,
        $columnIntro text not null,
        $columnAddress text not null,
        $columnGoogleLat text not null,
        $columnGoogleLon text not null,
        $columnBaiduLat text not null,
        $columnBaiduLon text not null,
        $columnLat text,
        $columnLon text,
        $columnDistance integer not null,
        $columnLocation text unique)
        ''');
  }

  Future<int> saveNote(Wifi wifi) async {
    var dbClient = await db;
//    var result = await dbClient.insert(tableNote, note.toMap());
    var result = await dbClient.rawInsert(
        'INSERT OR REPLACE INTO $tableName ($columnName, $columnIntro, $columnAddress, $columnGoogleLat, $columnGoogleLon, $columnBaiduLat, $columnBaiduLon, $columnLat, $columnLon, $columnDistance, $columnLocation) '
            'VALUES (\'${wifi.name}\', \'${wifi.intro}\', \'${wifi.address}\', \'${wifi.google_lat}\', \'${wifi.google_lon}\', \'${wifi.baidu_lat}\', \'${wifi.baidu_lon}\', \'${wifi.lat}\', \'${wifi.lon}\', \'${wifi.distance}\', \'${wifi.location}\')');

    return result;
  }

  Future<List<Wifi>> getAllNotes() async {
    var dbClient = await db;
//    var result = await dbClient.query(tableNote, columns: [columnId, columnTitle, columnDescription]);
    var result = await dbClient.rawQuery('SELECT * FROM $tableName');

    List<Wifi> wifis = List();
//    var resultList = result.toList();
    for(int i = 0; i < result.length; i ++) {
      wifis.add(new Wifi.fromMap(result[i]));
    }
    return wifis;
//    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  Future<Wifi> getNote(int id) async {
    var dbClient = await db;
//    List<Map> result = await dbClient.query(tableName,
//        columns: [columnId, columnTitle, columnDescription],
//        where: '$columnId = ?',
//        whereArgs: [id]);
    var result = await dbClient.rawQuery('SELECT * FROM $tableName WHERE $columnId = $id');

    if (result.length > 0) {
      return new Wifi.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteNote(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tableNote WHERE $columnId = $id');
  }

  Future<int> updateNote(Wifi wifi) async {
    var dbClient = await db;
    return await dbClient.update(tableName, wifi.toMap(), where: "$columnId = ?", whereArgs: [wifi.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tableNote SET $columnTitle = \'${note.title}\', $columnDescription = \'${note.description}\' WHERE $columnId = ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
