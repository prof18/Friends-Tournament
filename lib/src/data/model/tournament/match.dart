/// Different matches compose a tournament
/// Only ONE match can be active at the same time
class Match {
  String id;
  String name;
  int isActive;

  Match(this.id, this.name, this.isActive);

  @override
  String toString() {
    return 'Match{id: $id, name: $name, isActive: $isActive}';
  }
}
