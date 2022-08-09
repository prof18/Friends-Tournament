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
import 'package:friends_tournament/src/data/model/db/match_session.dart';

class MatchSessionDao implements Dao<MatchSession> {
  final columnMatchId = "id_match";
  final columnSessionId = "id_session";

  @override
  String get tableName => "matches_session";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnMatchId VARCHAR(255), "
      "$columnSessionId VARCHAR(255), "
      "PRIMARY KEY ($columnMatchId, $columnSessionId)"
      ")";

  @override
  List<MatchSession> fromList(List<Map<String, dynamic>> query) {
    var matchSessionList = <MatchSession>[];
    for (Map map in query) {
      matchSessionList.add(fromMap(map as Map<String, dynamic>));
    }
    return matchSessionList;
  }

  @override
  MatchSession fromMap(Map<String, dynamic> query) {
    var matchId = query[columnMatchId];
    var sessionId = query[columnSessionId];
    return MatchSession(matchId, sessionId);
  }

  @override
  Map<String, dynamic> toMap(MatchSession object) {
    return <String, dynamic>{
      columnMatchId: object.matchId,
      columnSessionId: object.sessionId
    };
  }
}
