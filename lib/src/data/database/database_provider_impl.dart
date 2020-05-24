/*
 * Copyright 2019 Marco Gomiero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:friends_tournament/src/data/database/dao/match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/match_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_player_dao.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// This class contains the db object that the applications requires.
/// For testing, we need to create a Fake Database provider
class DatabaseProviderImpl implements DatabaseProvider {
  static final _instance = DatabaseProviderImpl._internal();
  static DatabaseProviderImpl get = _instance;
  bool isInitialized = false;
  Database _db;

  // private constructor
  DatabaseProviderImpl._internal();

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

  @override
  Future<Database> db() async {
    if (_db == null) await _init();
    return _db;
  }

  @override
  Future<Database> closeDb() async {
    if (_db != null) {
      _db.close();
    }
  }
}
