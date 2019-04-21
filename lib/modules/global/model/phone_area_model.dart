
/// 手机归属地数据model
class PhoneArea {
  String province;	// 省份
  String city; 	// 城市，(北京、上海、重庆、天津直辖市可能为空)
  String areacode; //区号，(部分记录可能为空)
  String zip;  //	邮编，(部分记录可能为空)
  String company;
  String card;

  PhoneArea({this.province, this.city, this.areacode, this.zip,
      this.company, this.card});


  factory PhoneArea.fromJson(Map<String, dynamic> parsedJson){
    return PhoneArea(
        province: parsedJson['province'],
        city: parsedJson['city'],
        areacode: parsedJson['areacode'],
        zip: parsedJson['zip'],
        company: parsedJson['company'],
        card: parsedJson['card'],
    );
  }

  @override
  String toString() {
    return 'PhoneArea{province: $province, city: $city, areacode: $areacode, zip: $zip, company: $company}';
  } //	运营商
}


class PhoneAreaDto {
  String resultcode;
  String reason;
  PhoneArea result;
  int error_code;


  PhoneAreaDto({this.resultcode, this.reason, this.result, this.error_code});

  factory PhoneAreaDto.fromJson(Map<String, dynamic> parsedJson){
    return PhoneAreaDto(
      resultcode: parsedJson['resultcode'],
      reason: parsedJson['reason'],
      result: PhoneArea.fromJson(parsedJson['result']),
      error_code: parsedJson['error_code'],
    );
  }
}