import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tournament/main.dart' as app;
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Setup Tests error path', () {
    testWidgets(
        'Setting up a tournament with empty name is not possible',
            (WidgetTester tester) async {
          app.main();
          await tester.pumpAndSettle();

          // Welcome page
          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          // Tournament Name
          await tester.tap(find.byKey(setupNextButtonKey));
          await tester.pumpAndSettle();

          expect(find.byType(SnackBar), findsOneWidget);
        });
  });
}
