import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/model/db/match_session.dart';

class MatchSessionDao implements Dao<MatchSession> {
  final columnMatchId = "id_match";
  final columnSessionId = "id_session";

  @override
  String get tableName => "matches_session";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnMatchId VARCHAR(255), "
      "$columnSessionId VARCHAR(255), "
      "PRIMARY KEY ($columnMatchId, $columnSessionId)"
      ")";

  @override
  List<MatchSession> fromList(List<Map<String, dynamic>> query) {
    var matchSessionList = List<MatchSession>();
    for (Map map in query) {
      matchSessionList.add(fromMap(map));
    }
    return matchSessionList;
  }

  @override
  MatchSession fromMap(Map<String, dynamic> query) {
    var matchId = query[columnMatchId];
    var sessionId = query[columnSessionId];
    return MatchSession(matchId, sessionId);
  }

  @override
  Map<String, dynamic> toMap(MatchSession object) {
    return <String, dynamic>{
      columnMatchId: object.matchId,
      columnSessionId: object.sessionId
    };
  }
}
