import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils/test_utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  if (binding is LiveTestWidgetsFlutterBinding) {
    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  }

  group('Setup Tests error path', () {
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
