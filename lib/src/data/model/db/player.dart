import 'package:friends_tournament/src/data/database/dao/player_dao.dart';

/// Correspond to a row of the 'players' db table. [PlayerDao]
class Player {
  String id;
  String name;

  Player(this.id, this.name);

  @override
  String toString() {
    return 'Player{id: $id, name: $name}';
  }
}
