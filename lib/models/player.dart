class Player {
  final int id;
  final String name;
  int number;
  String position;
  String pictureUrl;

  Player({this.id, this.name, this.pictureUrl, this.number, this.position});

  String toString() {
    return "Player: $name";
  }
}
