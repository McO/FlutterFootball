class RoundsResponse {
  final int results;
  final List<String> rounds;

  const RoundsResponse({this.rounds, this.results});

  static RoundsResponse fromJson(Map<String, dynamic> json) {
    return RoundsResponse(
        rounds: ((json['response']) as List<dynamic>).cast<String>(), results: json['results'] as int);
  }
}
