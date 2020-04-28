class Area {
  final int id;
  final String name;
  final String countryCode;
  final String ensignUrl;

  const Area({this.id, this.name, this.countryCode, this.ensignUrl});

  static Area fromJson(dynamic json) {
    return Area(
        id: json['id'] as int,
        name: json['name'] as String,
        countryCode: json['countryCode'] as String,
        ensignUrl: json['ensignUrl'] as String);
  }
}

