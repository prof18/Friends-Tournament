import 'package:friends_tournament/src/data/database/dao/match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/match_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_player_dao.dart';
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
    if (_db == null) await _init();
    return _db;
  }

  Future _init() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "friends_tournament.db");

    // TODO: check if debug mode
    Sqflite.devSetDebugModeOn(true);

    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(MatchDao().createTableQuery);
      await db.execute(MatchSessionDao().createTableQuery);
      await db.execute(PlayerDao().createTableQuery);
      await db.execute(PlayerSessionDao().createTableQuery);
      await db.execute(SessionDao().createTableQuery);
      await db.execute(TournamentDao().createTableQuery);
      await db.execute(TournamentMatchDao().createTableQuery);
      await db.execute(TournamentPlayerDao().createTableQuery);
    });
  }

  // TODO: close db connection
}
