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

import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/setup_repository.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:test/test.dart';

import 'FakeDatabaseProvider.dart';
import 'test_tournament.dart';

void main() {

  group('Tournament setup database checks ->', () {
    SetupRepository setupRepository;
    TournamentRepository tournamentRepository;
    LocalDataSource localDataSource;

    setUpAll(() {
      DatabaseProvider databaseProvider = FakeDatabaseProvider.get;
      localDataSource = LocalDataSource(databaseProvider);

      setupRepository = SetupRepository(localDataSource);
      setupRepository.createTournament(
          TestTournament.playersNumber,
          TestTournament.playersAstNumber,
          TestTournament.matchesNumber,
          TestTournament.tournamentName,
          TestTournament.playersName,
          TestTournament.matchesName);

      tournamentRepository = TournamentRepository(localDataSource);
    });

    test('Add new tournament with an active one in the db throws exception',
        () async {
      await setupRepository.save();
      expect(() => setupRepository.save(),
          throwsA(isA<AlreadyActiveTournamentException>()));
    });

    test('Number of matches is correct', () async {
      // Current active tournament
      final tournament =
          await tournamentRepository.getCurrentActiveTournament();

      // Matches of the tournament
      final List<Map> dbMatches =
          await localDataSource.getTournamentMatches(tournament.id);

      // The tournament has 4 matches
      expect(dbMatches.length, TestTournament.matchesNumber);
    });

    test('Number of sessions is correct', () async {
      // Current active tournament
      final tournament =
          await tournamentRepository.getCurrentActiveTournament();

      // Matches of the tournament
      final List<Map> dbMatches =
          await localDataSource.getTournamentMatches(tournament.id);

      // The tournament has 4 matches
      expect(dbMatches.length, TestTournament.matchesNumber);

      await Future.forEach(dbMatches.toList(), (row) async {
        final String idMatch = row['id_match'];

        // Sessions of the match
        final List<Map> dbMatchSessions =
            await localDataSource.getMatchSessions(idMatch);

        // There are 4 players and 2 players can play at the same time -> 2 matches
        int sessionPerMatch =
            (TestTournament.playersNumber / TestTournament.playersAstNumber)
                .ceil();

        expect(dbMatchSessions.length, sessionPerMatch);
      });
    });

    test('Number of players is correct', () async {
      // Current active tournament
      final tournament =
          await tournamentRepository.getCurrentActiveTournament();

      // Matches of the tournament
      final List<Map> dbMatches =
          await localDataSource.getTournamentMatches(tournament.id);

      // The tournament has 4 matches
      expect(dbMatches.length, TestTournament.matchesNumber);

      await Future.forEach(dbMatches.toList(), (row) async {
        final String idMatch = row['id_match'];

        // Sessions of the match
        final List<Map> dbMatchSessions =
            await localDataSource.getMatchSessions(idMatch);

        await Future.forEach(dbMatchSessions.toList(), (row) async {
          final idSession = row['id_session'];

          // Player of the sessions
          final List<Map> dbPlayers =
              await localDataSource.getSessionPlayers(idSession);

          expect(dbPlayers.length, TestTournament.playersAstNumber);

        });
      });
    });

    test('Players combination is correct', () async {
      // Current active tournament
      final tournament =
      await tournamentRepository.getCurrentActiveTournament();

      // Matches of the tournament
      final List<Map> dbMatches =
      await localDataSource.getTournamentMatches(tournament.id);

      // The tournament has 4 matches
      expect(dbMatches.length, TestTournament.matchesNumber);

      await Future.forEach(dbMatches.toList(), (row) async {
        final String idMatch = row['id_match'];

        // Sessions of the match
        final List<Map> dbMatchSessions =
        await localDataSource.getMatchSessions(idMatch);

        // By using a set we ensure that the elements are not repeated
        Set matchPlayerSet = Set();

        await Future.forEach(dbMatchSessions.toList(), (row) async {
          final idSession = row['id_session'];

          // Player of the sessions
          final List<Map> dbPlayers =
          await localDataSource.getSessionPlayers(idSession);

          // By using a set we ensure that the elements are not repeated
          Set sessionPlayerSet = Set();

          await Future.forEach(dbPlayers.toList(), (row) async {
            final idPlayer = row['player_id'];

            matchPlayerSet.add(idPlayer);
            sessionPlayerSet.add(idPlayer);
          });
          expect(sessionPlayerSet.length, TestTournament.playersAstNumber);
        });
        expect(matchPlayerSet.length, TestTournament.playersNumber);
      });
    });
  });
}
