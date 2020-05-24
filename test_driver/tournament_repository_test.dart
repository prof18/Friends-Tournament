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
import 'package:friends_tournament/src/data/setup_repository.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';

import 'FakeDatabaseProvider.dart';
import 'test_tournament.dart';

void main() {
  group('Tournament repository tests ->', () {
    TournamentRepository tournamentRepository;
    LocalDataSource localDataSource;

    setUpAll(() async {
      DatabaseProvider databaseProvider = FakeDatabaseProvider.get;
      localDataSource = LocalDataSource(databaseProvider);

      final setupRepository = SetupRepository(localDataSource);
      await setupRepository.setupTournament(
          TestTournament.playersNumber,
          TestTournament.playersAstNumber,
          TestTournament.matchesNumber,
          TestTournament.tournamentName,
          TestTournament.playersName,
          TestTournament.matchesName);

      tournamentRepository = TournamentRepository(localDataSource);



    });

    test('Number of UI Matches is correct', () async {
      final tournament = await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(tournament.id);

      expect(uiMatches.length, TestTournament.matchesNumber);

    });

    test('Number of UI Sessions is correct', () async {
      final tournament = await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(tournament.id);

      uiMatches.forEach((uiMatch) {

        final uiSessions = uiMatch.matchSessions;

        int sessionPerMatch =
        (TestTournament.playersNumber / TestTournament.playersAstNumber)
            .ceil();

        expect(uiSessions.length, sessionPerMatch);

      });
    });

    test('First match should be active', () async {
      final tournament = await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(tournament.id);

      uiMatches.asMap().forEach((index, uiMatch)  {
        // The first match is active by default
        if (index == 0) {
          expect(uiMatch.isActive, 1);
        } else {
          expect(uiMatch.isActive, 0);
        }
      });
    });

    test('Players number for session is correct', () async {
      final tournament = await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(tournament.id);

      uiMatches.forEach((uiMatch)  {
        final uiSessions = uiMatch.matchSessions;

        uiSessions.forEach((uiSession) {
          final players = uiSession.sessionPlayers;
          expect(players.length, TestTournament.playersAstNumber);
        });
      });
    });

    test('Players score should be zero', () async {
      final tournament = await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(tournament.id);

      uiMatches.forEach((uiMatch)  {
        final uiSessions = uiMatch.matchSessions;

        uiSessions.forEach((uiSession) {
          final players = uiSession.sessionPlayers;

          players.forEach((player) {
            expect(player.score, 0);
          });
        });
      });
    });

    test('Players combinations are correct', () async {
      final tournament = await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(tournament.id);

      uiMatches.forEach((uiMatch)  {

        final matchPlayers = List<String>();
        final uiSessions = uiMatch.matchSessions;

        uiSessions.forEach((uiSession) {
          final players = uiSession.sessionPlayers;
          var sessionPlayers = List<String>();

          players.forEach((player) {
            sessionPlayers.add(player.id);
            matchPlayers.add(player.id);
          });

          expect(sessionPlayers.length, TestTournament.playersAstNumber);

        });

        expect(matchPlayers.length, TestTournament.playersNumber);
      });
    });

    // TODO: add test to end the match and the tournament

  });
}
