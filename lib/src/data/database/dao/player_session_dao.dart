import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/model/db/player_session.dart';

class PlayerSessionDao implements Dao<PlayerSession> {
  final columnPlayerId = "id_player";
  final columnSessionId = "id_session";
  final columnScore = "score";

  @override
  String get tableName => "player_session";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ("
      "$columnPlayerId VARCHAR(255), "
      "$columnSessionId VARCHAR(255), "
      "$columnScore INTEGER, "
      "PRIMARY KEY ($columnPlayerId, $columnSessionId)"
      ")";

  @override
  List<PlayerSession> fromList(List<Map<String, dynamic>> query) {
    var playerSessionList = List<PlayerSession>();
    for (Map map in query) {
      playerSessionList.add(fromMap(map));
    }
    return playerSessionList;
  }

  @override
  PlayerSession fromMap(Map<String, dynamic> query) {
    var playerId = query[columnPlayerId];
    var sessionId = query[columnSessionId];
    var score = query[columnScore];
    return PlayerSession(playerId, sessionId, score);
  }

  @override
  Map<String, dynamic> toMap(PlayerSession object) {
    return <String, dynamic>{
      columnPlayerId: object.playerId,
      columnSessionId: object.sessionId,
      columnScore: object.score
    };
  }
}
