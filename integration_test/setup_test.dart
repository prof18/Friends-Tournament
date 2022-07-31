import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'test_utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  final String tournamentName = "TournamentName";
  final String player1Name = "Player1";
  final String player2Name = "Player2";
  final String player3Name = "Player3";
  final String player4Name = "Player4";
  final String match1Name = "Match1";
  final String match2Name = "Match2";
  final String round1Name = "Round 1";
  final String round2Name = "Round 2";

  group('Setup Tests', () {
    testWidgets('Happy path with 4 players, 2 ast and 2 matches',
        (WidgetTester tester) async {
      // Start app
      await setupTournament(
        tester,
        tournamentName,
        [player1Name, player2Name, player3Name, player4Name],
        [match1Name, match2Name],
        2,
      );

      await checkTournament(
        tester,
        [match1Name, match2Name],
        [round1Name, round2Name],
        [player1Name, player2Name, player3Name, player4Name],
      );

      await tester.pumpAndSettle();
    });

    testWidgets(
        'Setting up a tournament with 3 players and 2 ast is not possible',
        (WidgetTester tester) async {
      await startAppAndSetTournamentName(tester, tournamentName);

      await setNumberOfPlayers(3, tester);

      await setupNumberOfPlayerAtSameTime(2, tester);

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
