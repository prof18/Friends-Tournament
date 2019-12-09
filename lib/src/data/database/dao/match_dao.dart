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
import 'package:friends_tournament/src/data/model/db/match.dart';

class MatchDao implements Dao<Match> {
  final columnId = "id";
  final columnName = "name";
  final columnActiveMatch = "is_active";
  final columnOrder = "match_order";

  @override
  String get tableName => "matches";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnId VARCHAR(255), "
      "$columnName TEXT, "
      "$columnActiveMatch INTEGER, "
      "$columnOrder INTEGER, "
      "PRIMARY KEY ($columnId)"
      ")";

  @override
  List<Match> fromList(List<Map<String, dynamic>> query) {
    var matches = List<Match>();
    for (Map map in query) {
      matches.add(fromMap(map));
    }
    return matches;
  }

  @override
  Match fromMap(Map<String, dynamic> query) {
    var matchId = query[columnId];
    var matchName = query[columnName];
    var isActive = query[columnActiveMatch];
    var order = query[columnOrder];
    return Match(matchId, matchName, isActive, order);
  }

  @override
  Map<String, dynamic> toMap(object) {
    return <String, dynamic>{
      columnId: object.id,
      columnName: object.name,
      columnActiveMatch: object.isActive,
      columnOrder: object.order
    };
  }
}
