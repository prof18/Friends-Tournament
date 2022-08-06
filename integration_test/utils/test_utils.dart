import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/tournament/session_player_tile.dart';

import '../../lib/main.dart' as app;

final String tournamentName = "TournamentName";
final String player1Name = "Player1";
final String player2Name = "Player2";
final String player3Name = "Player3";
final String player4Name = "Player4";
final String match1Name = "Match1";
final String match2Name = "Match2";
final String round1Name = "Round 1";
final String round2Name = "Round 2";

Future<void> setupTournament(
    WidgetTester tester,
    String tournamentName,
    List<String> players,
    List<String> matches,
    int playerAtTheSameTime,
    ) async {
  // Start app
  await startAppAndSetTournamentName(tester, tournamentName);

  // Number of Players
  await setNumberOfPlayers(players.length, tester);

  // Number of Players at the same time
  await setupNumberOfPlayerAtSameTime(playerAtTheSameTime, tester);

  // Number of matches
  for (int i = 0; i < matches.length - 1; i++) {
    await tester.tap(find.byKey(counterWidgetPlusButton));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byKey(setupNextButtonKey));
  await tester.pumpAndSettle();

  // Players name
  for (int i = 0; i < players.length; i++) {
    await tester.enterText(
      find.byKey(getKeyForPlayerNameTextField(i)),
      players[i],
    );
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byKey(setupNextButtonKey));
  await tester.pumpAndSettle();

  // Match Name
  for (int i = 0; i < matches.length; i++) {
    await tester.enterText(
      find.byKey(getKeyForMatchNameTextField(i)),
      matches[i],
    );
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byKey(setupNextButtonKey));
  await tester.pumpAndSettle();

  // Popup proceed
  await tester.tap(find.byKey(finishSetupProceedButtonKey));
  await tester.pumpAndSettle();
}

Future<void> setupNumberOfPlayerAtSameTime(int playerAtTheSameTime, WidgetTester tester) async {
  for (int i = 0; i < playerAtTheSameTime - 2; i++) {
    await tester.tap(find.byKey(setupNextButtonKey));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byKey(setupNextButtonKey));
  await tester.pumpAndSettle();
}

Future<void> setNumberOfPlayers(int players, WidgetTester tester) async {
  for (int i = 0; i < players - 2; i++) {
    await tester.tap(find.byKey(counterWidgetPlusButton));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byKey(setupNextButtonKey));
  await tester.pumpAndSettle();
}

Future<void> startAppAndSetTournamentName(WidgetTester tester, String tournamentName) async {
  app.main();
  await tester.pumpAndSettle();

  // Welcome page
  await tester.tap(find.byType(RaisedButton));
  await tester.pumpAndSettle();

  // Tournament Name
  await tester.enterText(find.byType(TextField), tournamentName);
  await tester.tap(find.byKey(setupNextButtonKey));
  await tester.pumpAndSettle();
}

Future<void> checkTournament(
    WidgetTester tester,
    List<String> matches,
    List<String> rounds,
    List<String> players,
    ) async {
  // Match view button
  await tester.tap(find.byKey(matchViewButtonKey));
  await tester.pumpAndSettle();

  // Match Name
  matches.forEach((match) {
    expect(find.text(match), findsWidgets);
  });

  // Close view
  await tester.tap(find.byKey(matchViewButtonKey));
  await tester.pumpAndSettle();

  // Round 1 and Round 2 are present
  for (int i = 0; i < rounds.length; i++) {
    expect(find.text(rounds[i]), findsOneWidget);

    // Score is zero
    var finder = find.byKey(getKeyForScore(i, rounds[i]));
    var widget = finder.evaluate().single.widget as SessionPlayerTile;
    var score = widget.player.score;
    expect(score, 0);
  }

  players.forEach((player) {
    // Players name are present
    expect(find.text(player), findsOneWidget);
  });
}