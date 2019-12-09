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

import 'package:friends_tournament/src/data/database/dao/match_session_dao.dart';

/// The session of a specific match
/// Correspond to a row of the 'matches_session' db table. [MatchSessionDao]
class MatchSession {
  String matchId;
  String sessionId;

  MatchSession(this.matchId, this.sessionId);

  @override
  String toString() {
    return 'MatchSession{matchId: $matchId, sessionId: $sessionId}';
  }
}
