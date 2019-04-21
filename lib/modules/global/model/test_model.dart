class Shape {
  String name;
  Property property;

  Shape({this.name, this.property});

  factory Shape.fromJson(Map<String, dynamic> json) {
    Property property = Property.fromJson(json['property']);   // new line
    return Shape(name: json['name'], property: property);
  }
}

class Property {
  double width;
  double height;

  Property({this.width, this.height});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(width: json['width'], height: json['height']);
  }
}