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
import 'package:friends_tournament/src/data/model/db/tournament_player.dart';

class TournamentPlayerDao implements Dao<TournamentPlayer> {
  final columnIdPlayer = "id_player";
  final columnIdTournament = "id_tournament";
  final columnFinalScore = "final_score";

  @override
  String get tableName => "tournament_player";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnIdPlayer VARCHAR(255), "
      "$columnIdTournament VARCHAR(255), "
      "$columnFinalScore INTEGER,"
      "PRIMARY KEY ($columnIdPlayer, $columnIdTournament)"
      ")";

  @override
  List<TournamentPlayer> fromList(List<Map<String, dynamic>> query) {
    var tournamentPlayerList = List<TournamentPlayer>();
    for (Map map in query) {
      tournamentPlayerList.add(fromMap(map));
    }
    return tournamentPlayerList;
  }

  @override
  TournamentPlayer fromMap(Map<String, dynamic> query) {
    var playerId = query[columnIdPlayer];
    var tournamentId = query[columnIdTournament];
    var finalScore = query[columnFinalScore];
    return TournamentPlayer(playerId, tournamentId, finalScore);
  }

  @override
  Map<String, dynamic> toMap(TournamentPlayer object) {
    return <String, dynamic>{
      columnIdPlayer: object.playerId,
      columnIdTournament: object.tournamentId,
      columnFinalScore: object.finalScore
    };
  }
}
