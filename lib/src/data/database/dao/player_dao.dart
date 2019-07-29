import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/model/player.dart';

class PlayerDao implements Dao<Player> {
  final columnId = "id";
  final columnName = "name";

  @override
  String get tableName => "players";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnId VARCHAR(255), "
      "$columnName TEXT, "
      "PRIMARY KEY ($columnId) "
      ")";

  @override
  List<Player> fromList(List<Map<String, dynamic>> query) {
    var players = List<Player>();
    for (Map map in query) {
      players.add(fromMap(map));
    }
    return players;
  }

  @override
  Player fromMap(Map<String, dynamic> query) {
    var playerId = query[columnId];
    var playerName = query[columnName];
    return Player(playerId, playerName);
  }

  @override
  Map<String, dynamic> toMap(Player object) {
    return <String, dynamic>{columnId: object.id, columnName: object.name};
  }
}
