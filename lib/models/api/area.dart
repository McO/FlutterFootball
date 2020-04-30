class Area {
  final int id;
  final String name;
  final String countryCode;
  final String ensignUrl;
  final int parentAreaId;
  final String parentArea;

  const Area({this.id, this.name, this.countryCode, this.ensignUrl, this.parentAreaId, this.parentArea});

  static Area fromJson(dynamic json) {
    return Area(
        id: json['id'] as int,
        name: json['name'] as String,
        countryCode: json['countryCode'] as String,
        ensignUrl: json['ensignUrl'] as String,
        parentAreaId: json['parentAreaId'] as int,
        parentArea: json['parentArea'] as String);
  }
}

class AreasResult {
  final List<Area> areas;

  const AreasResult({this.areas});

  static AreasResult fromJson(Map<String, dynamic> json) {
    final items = (json['areas'] as List<dynamic>).map((dynamic item) => Area.fromJson(item as Map<String, dynamic>)).toList();
    return AreasResult(areas: items);
  }
}
