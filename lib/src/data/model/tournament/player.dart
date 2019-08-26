class Player {
  String id;
  String name;

  Player(this.id, this.name);

  @override
  String toString() {
    return 'Player{id: $id, name: $name}';
  }
}
