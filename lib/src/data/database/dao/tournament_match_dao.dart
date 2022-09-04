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
import 'package:friends_tournament/src/data/model/db/tournament_match.dart';

class TournamentMatchDao implements Dao<TournamentMatch> {
  final columnTournamentId = "id_tournament";
  final columnMatchId = "id_match";

  @override
  String get tableName => "tournament_match";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ("
      "$columnTournamentId VARCHAR(255), "
      "$columnMatchId VARCHAR(255), "
      "PRIMARY KEY ($columnTournamentId, $columnMatchId)"
      ")";

  @override
  List<TournamentMatch> fromList(List<Map<String, dynamic>> query) {
    var tournamentMatchList = <TournamentMatch>[];
    for (Map map in query) {
      tournamentMatchList.add(fromMap(map as Map<String, dynamic>));
    }
    return tournamentMatchList;
  }

  @override
  TournamentMatch fromMap(Map<String, dynamic> query) {
    var tournamentId = query[columnTournamentId];
    var matchId = query[tournamentId];
    return TournamentMatch(tournamentId, matchId);
  }

  @override
  Map<String, dynamic> toMap(TournamentMatch object) {
    return <String, dynamic>{
      columnTournamentId: object.tournamentId,
      columnMatchId: object.matchId
    };
  }
}
