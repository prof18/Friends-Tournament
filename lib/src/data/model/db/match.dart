import 'package:friends_tournament/src/data/database/dao/match_dao.dart';

/// Different matches compose a tournament
/// Only ONE match can be active at the same time
/// Correspond to a row of the 'matches' db table. [MatchDao]
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
