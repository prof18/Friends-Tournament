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
import 'package:friends_tournament/src/data/model/db/tournament.dart';

class TournamentDao implements Dao<Tournament> {
  final columnId = "id";
  final columnName = "name";
  final columnPlayersNumber = "players_number";
  final columnAstPlayersNumber = "players_ast_number";
  final columnMatchesNumber = "matches_number";
  final columnActiveTournament = "is_active";

  @override
  String get tableName => "tournaments";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ("
      "$columnId VARCHAR(255), "
      "$columnName TEXT, "
      "$columnPlayersNumber INTEGER, "
      "$columnAstPlayersNumber INTEGER, "
      "$columnMatchesNumber INTEGER, "
      "$columnActiveTournament INTEGER, "
      "PRIMARY KEY ($columnId)"
      ")";

  @override
  List<Tournament> fromList(List<Map<String, dynamic>> query) {
    var tournaments = List<Tournament>();
    for (Map map in query) {
      tournaments.add(fromMap(map));
    }
    return tournaments;
  }

  @override
  Tournament fromMap(Map<String, dynamic> query) {
    var tournamentId = query[columnId];
    var tournamentName = query[columnName];
    var playersNumber = query[columnPlayersNumber];
    var playersAstNumber = query[columnAstPlayersNumber];
    var macthesNumber = query[columnMatchesNumber];
    var isActive = query[columnActiveTournament];
    return Tournament(tournamentId, tournamentName, playersNumber,
        playersAstNumber, macthesNumber, isActive);
  }

  @override
  Map<String, dynamic> toMap(Tournament object) {
    return <String, dynamic>{
      columnId: object.id,
      columnName: object.name,
      columnPlayersNumber: object.playersNumber,
      columnAstPlayersNumber: object.playersAstNumber,
      columnMatchesNumber: object.matchesNumber,
      columnActiveTournament: object.isActive
    };
  }
}
