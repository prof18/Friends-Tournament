import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils/test_utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Setup Test', () {
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
  });
}
