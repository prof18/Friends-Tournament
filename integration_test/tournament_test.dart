import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:integration_test/integration_test.dart';

import 'utils/test_utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Tournament Test', () {
    testWidgets('Compute winner with 4 players, 2 ast and 2 matches',
        (WidgetTester tester) async {
      await setupTournament(
        tester,
        tournamentName,
        [player1Name, player2Name, player3Name, player4Name],
        [match1Name, match2Name],
        2,
      );

      List<String> players = [
        player1Name,
        player2Name,
        player3Name,
        player4Name
      ];

      var match1Score = {
        player3Name: 3,
        player1Name: 2,
        player4Name: 2,
        player2Name: 1,
      };

      var match2Score = {
        player1Name: 3,
        player2Name: 1,
        player3Name: 3,
        player4Name: 1,
      };

      List<Map<String, int>> matches = [match1Score, match2Score];

      // Leaderboard check
      await tester.tap(find.byKey(leaderboardButtonKey));
      await tester.pumpAndSettle();
      checkLeaderboard(
        {
          player1Name: 0,
          player2Name: 0,
          player3Name: 0,
          player4Name: 0,
        },
      );
      await tester.tap(find.byKey(leaderboardBackButtonKey));
      await tester.pumpAndSettle();

      for (int i = 0; i < matches.length; i++) {
        final matchScore = matches[i];
        for (int j = 0; j < players.length; j++) {
          final player = players[j];
          var score = matchScore[player]!;
          debugPrint("Setting score: $score for player: $player");
          for (int k = 0; k < score; k++) {
            await tester.tap(find.byKey(getKeyForScoreIncrease(player)));
            await tester.pumpAndSettle();
          }
        }

        // Save match
        // To make sure that the snackbar is not showed anymore
        await Future<void>.delayed(const Duration(seconds: 3));
        await tester.tap(find.byKey(saveFabKey));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(saveScoreOkKey));
        await tester.pumpAndSettle();

        if (i == matches.length - 1) {
          await tester.tap(find.byKey(endTournamentKey));
          await tester.pumpAndSettle();
        } else {
          await tester.tap(find.byKey(leaderboardButtonKey));
          await tester.pumpAndSettle();
          checkLeaderboard(match1Score);
          await tester.tap(find.byKey(leaderboardBackButtonKey));
          await tester.pumpAndSettle();
        }
      }

      final finder = find.byKey(winnerTextKey);
      final widget = finder.evaluate().single.widget as Text;
      final name = widget.data!;
      expect(name.contains(player3Name), true);

      // Leaderboard check
      await tester.tap(find.byKey(tournamentEndedLeaderboardButtonKey));
      await tester.pumpAndSettle();
      checkLeaderboard(
        {
          player3Name: 6,
          player1Name: 5,
          player4Name: 3,
          player2Name: 2,
        },
      );
    });
  });
}

void checkLeaderboard(Map<String, int> finalScore) {
  finalScore.keys.forEachIndexed((index, key) {
    final positionWidget = find
        .byKey(getKeyForLeaderboardPlayerPosition(key))
        .evaluate()
        .single
        .widget as Text;
    final scoreWidget = find
        .byKey(getKeyForLeaderboardPlayerScore(key))
        .evaluate()
        .single
        .widget as Text;

    expect(positionWidget.data, (index + 1).toString());
    expect(scoreWidget.data, finalScore[key].toString());
  });
}
