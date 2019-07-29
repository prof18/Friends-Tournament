import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';

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

  void insert(dynamic object, Dao dao) async {
    final db = await databaseProvider.db();
    db.insert(dao.tableName, dao.toMap(object));
  }

  Future<dynamic> getItems(Dao dao) async {
    final db = await databaseProvider.db();
    List<dynamic> results = await db.query(dao.tableName);
    return dao.fromList(results);
  }
}
