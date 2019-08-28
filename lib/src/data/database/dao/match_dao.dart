import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/model/db/match.dart';

class MatchDao implements Dao<Match> {
  final columnId = "id";
  final columnName = "name";
  final columnActiveMatch = "is_active";

  @override
  String get tableName => "matches";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnId VARCHAR(255), "
      "$columnName TEXT, "
      "$columnActiveMatch INTEGER, "
      "PRIMARY KEY ($columnId)"
      ")";

  @override
  List<Match> fromList(List<Map<String, dynamic>> query) {
    var matches = List<Match>();
    for (Map map in query) {
      matches.add(fromMap(map));
    }
    return matches;
  }

  @override
  Match fromMap(Map<String, dynamic> query) {
    var matchId = query[columnId];
    var matchName = query[columnName];
    var isActive = query[columnActiveMatch];
    return Match(matchId, matchName, isActive);
  }

  @override
  Map<String, dynamic> toMap(object) {
    return <String, dynamic>{
      columnId: object.id,
      columnName: object.name,
      columnActiveMatch: object.isActive
    };
  }
}
