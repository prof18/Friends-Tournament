/*
 * Copyright 2020 Marco Gomiero
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

import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/model/app/ui_final_score.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/db/ongoing_database_provider.dart';
import '../utils/test_tournament.dart';


void main() {
  // Init ffi loader if needed.
  sqfliteFfiInit();

  group('Tournament repository ongoing tests', () {

    LocalDataSource localDataSource;
    DatabaseProvider databaseProvider = DatabaseProviderFromSQL.get;
    localDataSource = LocalDataSource(databaseProvider);

    final tournamentRepository = TournamentRepository(localDataSource);

    test('Number of scores is equal to number of players', () async {
      final currentTournament = await tournamentRepository.getCurrentActiveTournament();
      final scores = await tournamentRepository.getScore(currentTournament!);
      expect(scores.length, TestTournament.playersNumber);
    });

    test('list of scores is correct', () async {
      final currentTournament = await tournamentRepository.getCurrentActiveTournament();
      final scores = await tournamentRepository.getScore(currentTournament!);

      List<UIScore> uiScores = <UIScore>[];
      uiScores.add(UIScore(score: 5, id: "761153207", name: "Player 1"));
      uiScores.add(UIScore(score: 3, id: "183402969", name: "Player 3"));
      uiScores.add(UIScore(score: 1, id: "479405346", name: "Player 2"));
      uiScores.add(UIScore(score: 1, id: "942660699", name: "Player 4"));

      expect(scores[0].id, uiScores[0].id);
      expect(scores[0].score, uiScores[0].score);

      expect(scores[1].id, uiScores[1].id);
      expect(scores[1].score, uiScores[1].score);

      expect(scores[2].id, uiScores[2].id);
      expect(scores[2].score, uiScores[2].score);

      expect(scores[3].id, uiScores[3].id);
      expect(scores[3].score, uiScores[3].score);

    });

  });
}