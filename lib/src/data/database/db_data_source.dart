import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/db_queries.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DBDataSource {
  // Implement singleton
  // To get back it, simple call: MyClass myObj = new MyClass();
  /// -------
  static final DBDataSource _singleton = new DBDataSource._internal();

  factory DBDataSource() {
    return _singleton;
  }

  DBDataSource._internal();

  /// -------

  // TODO: close db connection

  var databaseProvider = DatabaseProvider.get;
  Batch _batch;

  Future insert(dynamic object, Dao dao) async {
    final db = await databaseProvider.db();
    await db.insert(dao.tableName, dao.toMap(object));
  }

  Future insertIgnore(dynamic object, Dao dao) async {
    final db = await databaseProvider.db();
    await db.insert(dao.tableName, dao.toMap(object),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<dynamic> getItems(Dao dao) async {
    final db = await databaseProvider.db();
    List<dynamic> results = await db.query(dao.tableName);
    return dao.fromList(results);
  }

  Future createBatch() async {
    final db = await databaseProvider.db();
    _batch = db.batch();
  }

  void insertToBatch(dynamic object, Dao dao) {
    _batch.insert(dao.tableName, dao.toMap(object));
  }

  void insertIgnoreToBatch(dynamic object, Dao dao) {
    _batch.insert(dao.tableName, dao.toMap(object),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future flushBatch() async {
    await _batch.commit();
    _batch = null;
  }

  /// Return the active tournament
  /// There should be always one active match. If not, it returns the first one.
  Future<Tournament> getActiveTournament(Dao dao) async {
    final db = await databaseProvider.db();
    List<Map> maps =
        await db.query(dao.tableName, where: 'is_active = ?', whereArgs: [1]);
    if (maps.length > 0) {
      return dao.fromMap(maps.first);
    }
    return null;
  }

  /// Returns all the matches of the tournament provided as input
  Future<List<Map>> getTournamentMatches(String tournamentId) async {
    final db = await databaseProvider.db();
    List<Map> result = await db.rawQuery(
        format(allMatchesForActiveTournamentQuery, tournamentId));
    return result;
  }

  /// Returns all the session for a specific match
  Future<List<Map>> getMatchSessions(String matchId) async {
    final db = await databaseProvider.db();
    List<Map> result =
        await db.rawQuery(format(getMatchSessionsQuery, matchId));
    return result;
  }

  /// Returns all the players for a specific session
  Future<List<Map>> getSessionPlayers(String sessionId) async {
    final db = await databaseProvider.db();
    List<Map> results = await db.rawQuery(format(getSessionPlayersQuery, sessionId));
    return results;
  }
}
