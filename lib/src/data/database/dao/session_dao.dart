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
import 'package:friends_tournament/src/data/model/db/session.dart';

class SessionDao implements Dao<Session> {
  final columnId = "id";
  final columnName = "name";
  final columnOrder = "session_order";

  @override
  String get tableName => "sessions";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnId VARCHAR(255), "
      "$columnName TEXT, "
      "$columnOrder INTEGER, "
      "PRIMARY KEY ($columnId)"
      ")";

  @override
  List<Session> fromList(List<Map<String, dynamic>> query) {
    var sessions = <Session>[];
    for (Map map in query) {
      sessions.add(fromMap(map as Map<String, dynamic>));
    }
    return sessions;
  }

  @override
  Session fromMap(Map<String, dynamic> query) {
    var sessionId = query[columnId];
    var sessionName = query[columnName];
    var order = query[columnOrder];
    return Session(sessionId, sessionName, order);
  }

  @override
  Map<String, dynamic> toMap(Session object) {
    return <String, dynamic>{
      columnId: object.id,
      columnName: object.name,
      columnOrder: object.order
    };
  }
}
