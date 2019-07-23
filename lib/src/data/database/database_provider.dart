import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final _instance = DatabaseProvider._internal();
  static DatabaseProvider get = _instance;
  bool isInitialized = false;
  Database _db;

  // private constructor
  DatabaseProvider._internal();

  Future<Database> db() async {
    if (_db != null) await _init();
    return _db;
  }

 Future _init() async {
   var databasePath = await getDatabasesPath();
   String path = join(databasePath, "friends_tournament.db");

   _db = await openDatabase(
       databasePath,
       version: 1,
       onCreate: (Database db, int version) async {
         // TODO: add all the queries to create the tables
//        await db.execute()
   } );
 }

}