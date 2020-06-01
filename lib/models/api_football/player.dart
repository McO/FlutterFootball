class Player {
  final int id;
  final String name;
  final String photo;
  final int number;
  final String pos;

  const Player({this.id, this.name, this.photo, this.number, this.pos});

  static Player fromJson(dynamic json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      photo: json['photo'] as String,
      number: json['number'] as int,
      pos: json['pos'] as String,
    );
  }
}