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

import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';

/// A tournament is played by [playersNumber] different player and the can be
/// a fixed number of players that plays at the same time [playersAstNumber].
/// A tournament is composed by different number of matches [matchesNumber].
/// Due to the 'player at the same time constraint', a match is divided in sessions.
/// Correspond to a row of the 'tournaments' db table [TournamentDao]
class Tournament {
  String id;
  String name;
  int playersNumber;
  int playersAstNumber;
  int matchesNumber;
  // 0 inactive, 1 active
  int isActive;
  int date;

  Tournament(
    this.id,
    this.name,
    this.playersNumber,
    this.playersAstNumber,
    this.matchesNumber,
    this.isActive,
    this.date,
  );

  @override
  String toString() {
    return 'Tournament{id: $id, name: $name, playersNumber: $playersNumber, playersAstNumber: $playersAstNumber, matchesNumber: $matchesNumber, isActive: $isActive, date: $date}';
  }
}
