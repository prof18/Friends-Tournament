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

import 'package:friends_tournament/src/data/database/dao/player_session_dao.dart';

/// The player of a specific sessions
/// Correspond to a row of the 'player_session' db table. [PlayerSessionDao]
class PlayerSession {
  String playerId;
  String sessionId;
  int score;

  PlayerSession(this.playerId, this.sessionId, this.score);

  @override
  String toString() {
    return 'PlayerSession{playerId: $playerId, sessionId: $sessionId, score: $score}';
  }
}
