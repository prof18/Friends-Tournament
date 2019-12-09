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

import 'package:friends_tournament/src/data/database/dao/session_dao.dart';

/// A match is composed by a different number of sessions,
/// due to the player at the same time constraint
/// Correspond to a row of the 'session' db table. [SessionDao]
class Session {
  String id;
  String name;
  int order;

  Session(this.id, this.name, this.order);

  @override
  String toString() {
    return 'Session{id: $id, name: $name, order: $order}';
  }
}
