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

import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/match.dart' as tournament;

/// This objects is used to hold all the info about a match that are needed in
/// the UI, for example all the session of the match.
/// It is an extensions of the [] saved in the db.
class UIMatch extends tournament.Match {
  List<UISession> matchSessions;
  bool isSelected = false;

  /// If there is at least one player with a score different than zero, it means
  /// that that match has been saved once
  bool hasAlreadyScore() {
    bool hasScore = false;

    matchSessions.forEach((matchSession) {
      final playersWithScore = matchSession.sessionPlayers.where((element) => element.score != 0).toList();
      if (playersWithScore.isNotEmpty) {
        hasScore = true;
      }
    });

    return hasScore;
  }

  UIMatch({required this.matchSessions, id, name, isActive, order})
      : super(id, name, isActive, order);

  tournament.Match getParent() {
    return tournament.Match(id, name, isActive, order);
  }
}
