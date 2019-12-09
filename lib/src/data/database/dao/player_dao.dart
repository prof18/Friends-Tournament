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
import 'package:friends_tournament/src/data/model/db/player.dart';

class PlayerDao implements Dao<Player> {
  final columnId = "id";
  final columnName = "name";

  @override
  String get tableName => "players";

  @override
  String get createTableQuery => "CREATE TABLE $tableName ( "
      "$columnId VARCHAR(255), "
      "$columnName TEXT, "
      "PRIMARY KEY ($columnId) "
      ")";

  @override
  List<Player> fromList(List<Map<String, dynamic>> query) {
    var players = List<Player>();
    for (Map map in query) {
      players.add(fromMap(map));
    }
    return players;
  }

  @override
  Player fromMap(Map<String, dynamic> query) {
    var playerId = query[columnId];
    var playerName = query[columnName];
    return Player(playerId, playerName);
  }

  @override
  Map<String, dynamic> toMap(Player object) {
    return <String, dynamic>{columnId: object.id, columnName: object.name};
  }
}
