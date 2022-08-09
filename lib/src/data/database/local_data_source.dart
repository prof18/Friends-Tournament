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

import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/database/dao/match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_player_dao.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/db_queries.dart';
import 'package:friends_tournament/src/data/model/db/match.dart' as tournament;
import 'package:friends_tournament/src/data/model/db/player_session.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/data/model/db/tournament_player.dart';
import 'package:friends_tournament/src/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

// TODO: does it make sense to have it as a singleton?
class LocalDataSource {
  // Implement singleton
  // To get back it, simple call: MyClass myObj = new MyClass();
  /// -------
  static final LocalDataSource _singleton = new LocalDataSource._internal();

  late DatabaseProvider databaseProvider;

  LocalDataSource._internal();

  factory LocalDataSource(DatabaseProvider databaseProvider) {
    _singleton.databaseProvider = databaseProvider;
    return _singleton;
  }

  /// -------

  Batch? _batch;

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
    return dao.fromList(results as List<Map<String, dynamic>>);
  }

  Future createBatch() async {
    final db = await databaseProvider.db();
    _batch = db.batch();
  }

  void insertToBatch(dynamic object, Dao dao) {
    _batch?.insert(dao.tableName, dao.toMap(object));
  }

  void insertIgnoreToBatch(dynamic object, Dao dao) {
    _batch?.insert(
      dao.tableName,
      dao.toMap(object),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future flushBatch() async {
    await _batch?.commit();
    _batch = null;
  }

  /// Return the active tournament
  /// There should be always one active match. If not, it returns the first one.
  Future<Tournament?> getActiveTournament(Dao dao) async {
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(
      dao.tableName,
      where: 'is_active = ?',
      whereArgs: [1],
    );
    if (maps.length > 0) {
      return dao.fromMap(maps.first as Map<String, dynamic>);
    }
    return null;
  }

  /// Used to fix eventual errors. Get all the tournaments
  Future<List<Tournament>> getAllTournaments() async {
    TournamentDao dao = TournamentDao();
    final db = await databaseProvider.db();
    List<Map> maps = await db.query(dao.tableName);
    if (maps.length > 0) {
      return dao.fromList(maps as List<Map<String, dynamic>>);
    }
    return [];
  }

  /// Return all the tournaments saved in the db
  Future<Tournament?> getLastTournament() async {
    final db = await databaseProvider.db();
    final dao = TournamentDao();
    List<Map> maps = await db.query(
      dao.tableName,
      where: 'is_active = ?',
      whereArgs: [0],
      orderBy: "date DESC",
    );
    List<Tournament> tournaments = dao.fromList(
      maps as List<Map<String, dynamic>>,
    );

    if (tournaments.isNotEmpty) {
      return tournaments.first;
    }

    return Future.value(null);
  }

  /// Returns all the matches of the tournament provided as input
  Future<List<Map>> getTournamentMatches(String tournamentId) async {
    final db = await databaseProvider.db();
    List<Map> result = await db.rawQuery(
      format(allMatchesForActiveTournamentQuery, tournamentId),
    );
    return result;
  }

  /// Returns all the session for a specific match
  Future<List<Map>> getMatchSessions(String matchId) async {
    final db = await databaseProvider.db();
    List<Map> result = await db.rawQuery(
      format(getMatchSessionsQuery, matchId),
    );
    return result;
  }

  /// Returns all the players for a specific session
  Future<List<Map>> getSessionPlayers(String sessionId) async {
    final db = await databaseProvider.db();
    List<Map> results = await db.rawQuery(
      format(getSessionPlayersQuery, sessionId),
    );
    return results;
  }

  Future<void> updateMatch(tournament.Match match) async {
    final db = await databaseProvider.db();
    final MatchDao dao = MatchDao();
    await db.update(
      dao.tableName,
      dao.toMap(match),
      where: dao.columnId + " = ?",
      whereArgs: [match.id],
    );
    return;
  }

  Future<void> updatePlayerSession(PlayerSession playerSession) async {
    final db = await databaseProvider.db();
    final PlayerSessionDao dao = PlayerSessionDao();
    await db.update(
      dao.tableName,
      dao.toMap(playerSession),
      where: dao.columnSessionId + " = ? AND " + dao.columnPlayerId + " = ?",
      whereArgs: [playerSession.sessionId, playerSession.playerId],
    );
    return;
  }

  Future<void> updateTournamentPlayer(TournamentPlayer tournamentPlayer) async {
    final db = await databaseProvider.db();
    final TournamentPlayerDao dao = TournamentPlayerDao();
    await db.update(
      dao.tableName,
      dao.toMap(tournamentPlayer),
      where: dao.columnIdTournament + " = ? AND " + dao.columnIdPlayer + " = ?",
      whereArgs: [tournamentPlayer.tournamentId, tournamentPlayer.playerId],
    );
  }

  Future<List<TournamentPlayer>> getTournamentPlayers(
    String tournamentId,
  ) async {
    final db = await databaseProvider.db();
    final TournamentPlayerDao dao = TournamentPlayerDao();
    List<Map> results = await db.query(
      dao.tableName,
      where: 'id_tournament = ?',
      whereArgs: [tournamentId],
    );
    return dao.fromList(results as List<Map<String, dynamic>>);
  }

  Future<void> updateTournament(Tournament tournament) async {
    final db = await databaseProvider.db();
    final TournamentDao dao = TournamentDao();
    await db.update(
      dao.tableName,
      dao.toMap(tournament),
      where: dao.columnId + " = ?",
      whereArgs: [tournament.id],
    );
  }

  Future<List<Map>> getTournamentScore(String? tournamentId) async {
    final db = await databaseProvider.db();
    List<Map> results = await db.rawQuery(
      format(getTournamentScoreQuery, tournamentId),
    );
    return results;
  }
}
