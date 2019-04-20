
/// 手机归属地数据model
class PhoneArea {
  String province;	// 省份
  String city; 	// 城市，(北京、上海、重庆、天津直辖市可能为空)
  String areacode; //区号，(部分记录可能为空)
  String zip;  //	邮编，(部分记录可能为空)
  String company;

  PhoneArea(this.province, this.city, this.areacode, this.zip,
      this.company);

  @override
  String toString() {
    return 'PhoneArea{province: $province, city: $city, areacode: $areacode, zip: $zip, company: $company}';
  } //	运营商
}