import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/setup_repository.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/db/fake_database_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  int playersNumber = 13;
  int playersAstNumber = 2;
  int matchesNumber = 1;

  group('Tournament repository setup with a round of one player tests ->', () {
    late TournamentRepository tournamentRepository;
    late SetupRepository setupRepository;
    LocalDataSource localDataSource;

    setUpAll(() async {
      DatabaseProvider databaseProvider = FakeDatabaseProvider.get;
      localDataSource = LocalDataSource(databaseProvider);

      setupRepository = SetupRepository(localDataSource);

      String tournamentName = "Test Tournament";
      Map<int, String> playersName = {
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
      };
      Map<int, String> matchesName = {
        0: "Match1",
      };

      await setupRepository.setupTournament(
        playersNumber,
        playersAstNumber,
        matchesNumber,
        tournamentName,
        playersName,
        matchesName,
      );

      tournamentRepository = TournamentRepository(localDataSource);
    });

    test('Number of UI Matches is correct', () async {
      final tournament =
          await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(
        tournament!.id,
      );

      expect(uiMatches.length, matchesNumber);
    });

    test('Number of UI Sessions is correct', () async {
      final tournament =
          await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(
        tournament!.id,
      );

      for (var uiMatch in uiMatches) {
        final uiSessions = uiMatch.matchSessions;

        int sessionPerMatch =
            (playersNumber / playersAstNumber)
                .ceil();

        expect(uiSessions.length, sessionPerMatch);
      }
    });

    test('One session has only one player', () async {
      final tournament =
          await tournamentRepository.getCurrentActiveTournament();
      final uiMatches = await tournamentRepository.getTournamentMatches(
        tournament!.id,
      );

      for (var uiMatch in uiMatches) {
        final uiSessions = uiMatch.matchSessions;

        final playersList = uiSessions
            .where((element) => element.sessionPlayers.length == 1)
            .toList();
        expect(playersList.length, 1);
      }
    });
  });
}
