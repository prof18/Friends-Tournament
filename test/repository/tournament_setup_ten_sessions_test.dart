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
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/setup_repository.dart';

void main() {

  group('Tournament Setup Ten Sessions Tests', () {

    // We provide these dependencies even if here is not used
    DatabaseProvider databaseProvider = DatabaseProviderImpl.get;
    LocalDataSource localDataSource = LocalDataSource(databaseProvider);
    final SetupRepository setupRepository = SetupRepository(localDataSource);

   const int playersNumber = 20;
   const int playersAstNumber = 2;
   const int matchesNumber = 2;
   const String tournamentName = "Test Tournament";
   final Map<int, String> playersName = {
      0: "Player1",
      1: "Player2",
      2: "Player3",
      3: "Player4",
      4: "Player5",
      5: "Player6",
      6: "Player7",
      7: "Player8",
      8: "Player9",
      9: "Player10",
      10: "Player11",
      11: "Player12",
      12: "Player13",
      13: "Player14",
      14: "Player15",
      15: "Player16",
      16: "Player17",
      17: "Player18",
      18: "Player19",
      19: "Player20",
    };
    final Map<int, String> matchesName = {
      0: "Match1",
      1: "Match2",
    };

    setUpAll(() {
      setupRepository.createTournament(
          playersNumber,
          playersAstNumber,
          matchesNumber,
          tournamentName,
          playersName,
          matchesName);
    });

    test('sessions number are correct', () {
      final sessionsNumber =
      (playersNumber / playersAstNumber).ceil();
      expect(sessionsNumber * matchesNumber,
          setupRepository.sessions.length);
    });

  });

}