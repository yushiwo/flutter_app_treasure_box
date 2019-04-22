/// 当天星座运势详情
class StarDetail {
  ///{"date":20190422,"name":"双子座","datetime":"2019年04月22日","all":"40%","color":"草青色","health":"70%","love":"40%","money":"20%","number":9,"QFriend":"天秤座","summary":"今天略感身体不适，压抑。部分人有三角恋，副业之类","work":"60%","resultcode":"200","error_code":0}
  ///

  String name; /*星座名称*/
  int date;  /*日期简写*/
  String datetime; /*日期*/
  String all; /*综合指数*/
  String color; /*幸运色*/
  String health; /*健康指数*/
  String love; /*爱情指数*/
  String money; /*财运指数*/
  int number; /*幸运数字*/
  String QFriend; /*速配星座*/
  String summary; /*今日概述*/
  String work; /*工作指数*/
  String resultcode;
  int error_code; /*返回码*/

  StarDetail({this.name, this.date, this.datetime, this.all, this.color,
      this.health, this.love, this.money, this.number, this.QFriend,
      this.summary, this.work, this.resultcode, this.error_code});

  factory StarDetail.fromJson(Map<String, dynamic> parsedJson){
    return StarDetail(
      name: parsedJson['name'],
      date: parsedJson['date'],
      datetime: parsedJson['datetime'],
      all: parsedJson['all'],
      color: parsedJson['color'],
      health: parsedJson['health'],
      love: parsedJson['love'],
      money: parsedJson['money'],
      number: parsedJson['number'],
      QFriend: parsedJson['QFriend'],
      summary: parsedJson['summary'],
      work: parsedJson['work'],
      resultcode: parsedJson['resultcode'],
      error_code: parsedJson['error_code'],
    );
  }


}