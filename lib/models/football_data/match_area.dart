class MatchArea {
  final String name;
  final String countryCode;
  final String ensignUrl;

  const MatchArea({this.name, this.countryCode, this.ensignUrl});

  static MatchArea fromJson(dynamic json) {
    return MatchArea(
        name: json['name'] as String, countryCode: json['code'] as String, ensignUrl: json['ensignUrl'] as String);
  }
}
