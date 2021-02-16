class Country {
  final String name;
  final String code;
  final String flag;

  const Country({this.name, this.code, this.flag});

  static Country fromJson(dynamic json) {
    return Country(name: json['name'] as String, code: json['code'] as String, flag: json['flag'] as String);
  }
}

class CountriesResult {
  final List<Country> countries;

  const CountriesResult({this.countries});

  static CountriesResult fromJson(Map<String, dynamic> json) {
    final items = (json['response'] as List<dynamic>)
        .map((dynamic item) => Country.fromJson(item as Map<String, dynamic>))
        .toList();
    return CountriesResult(countries: items);
  }
}
