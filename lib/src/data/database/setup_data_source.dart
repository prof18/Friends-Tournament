import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/model/tournament/tournament.dart';
import 'package:sqflite/sqflite.dart';

class SetupDataSource {
  // Implement singleton
  // To get back it, simple call: MyClass myObj = new MyClass();
  /// -------
  static final SetupDataSource _singleton = new SetupDataSource._internal();

  factory SetupDataSource() {
    return _singleton;
  }

  SetupDataSource._internal();

  /// -------

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

  Future<Tournament> getActiveTournament(Dao dao) async {
    final db = await databaseProvider.db();
    List<Map> maps =
        await db.query(dao.tableName, where: 'is_active = ?', whereArgs: [1]);
    if (maps.length > 0) {
      return dao.fromMap(maps.first);
    }
    return null;
  }
}
