class Player {
  final int id;
  final String name;
  String pictureUrl;

  Player({this.id, this.name, this.pictureUrl});

  String toString() {
    return "Player: $name";
  }
}
