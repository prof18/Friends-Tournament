import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/model/db/session.dart';

class SessionDao implements Dao<Session> {
  final columnId = "id";
  final columnName = "name";
  final columnOrder = "session_order";

  @override
  String get tableName => "sessions";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnId VARCHAR(255), "
      "$columnName TEXT, "
      "$columnOrder INTEGER, "
      "PRIMARY KEY ($columnId)"
      ")";

  @override
  List<Session> fromList(List<Map<String, dynamic>> query) {
    var sessions = List<Session>();
    for (Map map in query) {
      sessions.add(fromMap(map));
    }
    return sessions;
  }

  @override
  Session fromMap(Map<String, dynamic> query) {
    var sessionId = query[columnId];
    var sessionName = query[columnName];
    var order = query[columnOrder];
    return Session(sessionId, sessionName, order);
  }

  @override
  Map<String, dynamic> toMap(Session object) {
    return <String, dynamic>{
      columnId: object.id,
      columnName: object.name,
      columnOrder: object.order
    };
  }
}
