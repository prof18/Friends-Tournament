/*
 * Copyright 2020 Marco Gomiero
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
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../test_tournament.dart';

class DatabaseProviderFromSQL implements DatabaseProvider {
  static final _instance = DatabaseProviderFromSQL._internal();
  static DatabaseProviderFromSQL get = _instance;
  bool isInitialized = false;
  Database _db;

  // private constructor
  DatabaseProviderFromSQL._internal();

  Future _init() async {
//    Sqflite.devSetDebugModeOn(true);

    var factory = databaseFactoryFfi;

    _db = await factory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(MatchDao().createTableQuery);
          await db.execute(TestTournament.onGoingMatchesInsertQuery);

          await db.execute(MatchSessionDao().createTableQuery);
          await db.execute(TestTournament.onGoingMatchesSessionInsertQuery);

          await db.execute(PlayerSessionDao().createTableQuery);
          await db.execute(TestTournament.onGoingPlayerSessionInsertQuery);

          await db.execute(PlayerDao().createTableQuery);
          await db.execute(TestTournament.onGoingPlayerInsertQuery);

          await db.execute(SessionDao().createTableQuery);
          await db.execute(TestTournament.onGoingSessionInsertQuery);

          await db.execute(TournamentMatchDao().createTableQuery);
          await db.execute(TestTournament.onGoingTournamentMatchInsertQuery);

          await db.execute(TournamentPlayerDao().createTableQuery);
          await db.execute(TestTournament.onGoingTournamentPlayerInsertQuery);

          await db.execute(TournamentDao().createTableQuery);
          await db.execute(TestTournament.onGoingTournamentInsertQuery);
        },
      ),
    );
  }

  @override
  Future<Database> db() async {
    if (_db == null) await _init();
    return _db;
  }

  @override
  Future<Database> closeDb() {
    if (_db != null) {
      _db.close();
    }
  }
}
