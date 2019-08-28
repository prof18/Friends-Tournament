import 'package:friends_tournament/src/data/database/dao/session_dao.dart';

/// A match is composed by a different number of sessions,
/// due to the player at the same time constraint
/// Correspond to a row of the 'session' db table. [SessionDao]
class Session {
  String id;
  String name;
  // 0 inactive, 1 active
  int isActive;

  Session(this.id, this.name, this.isActive);

  @override
  String toString() {
    return 'Session{id: $id, name: $name, isActive: $isActive}';
  }
}
