class Player {
  final int id;
  final String name;
  final String photo;

  const Player({this.id, this.name, this.photo});

  static Player fromJson(dynamic json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      photo: json['photo'] as String,
    );
  }
}