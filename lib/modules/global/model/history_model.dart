/// 历史上的今天相关DO

class History {
//  "_id":"18141001",
//  "title":"反法联盟各参加国在奥地利首都维也纳召开会议",
//  "pic":"http://juheimg.oss-cn-hangzhou.aliyuncs.com/toh/201110/2/1F81726127.jpg",
//  "year":1814,
//  "month":10,
//  "day":1,
//  "des":"在205年前的今天，1814年10月1日 (农历八月十八)，反法联盟各参加国在奥地利首都维也纳召开会议。",
//  "lunar":"甲戌年八月十八"

  String id;
  String title;
  String pic;
  int year;
  int month;
  int day;

  History(this.id, this.title, this.pic, this.year, this.month, this.day);

  @override
  String toString() {
    return 'History{id: $id, title: $title, pic: $pic, year: $year, month: $month, day: $day}';
  }


}