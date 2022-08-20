import 'package:flutter/widgets.dart';

const setupNextButtonKey = ValueKey('nextSetupButton');
const setupBackButtonKey = ValueKey('backSetupButton');

const counterWidgetPlusButton = ValueKey("counterWidgetPlusButton");
const counterWidgetMinusButton = ValueKey("counterWidgetMinusButton");

const finishSetupProceedButtonKey = ValueKey("setupPopupProceedButton");

const matchViewButtonKey = ValueKey('matchViewButton');

const saveFabKey = ValueKey('saveFab');

const saveScoreOkKey = ValueKey('saveScoreOkButton');

const endTournamentKey = ValueKey('endTournamentOkButton');

const tournamentEndedLeaderboardButtonKey = ValueKey(
  'tournamentEndLeaderboardButton',
);

const winnerTextKey = ValueKey('winnerTextKey');

const leaderboardButtonKey = ValueKey('leaderboardButton');

const leaderboardBackButtonKey = ValueKey('leaderboardBackButton');

ValueKey getKeyForPlayerNameTextField(int index) {
  return ValueKey("playerName-$index");
}

ValueKey getKeyForMatchNameTextField(int index) {
  return ValueKey("matchName-$index");
}

ValueKey getKeyForMatchSelector(int index) {
  return ValueKey("matchSelection-$index");
}

ValueKey getKeyForScore(int index, String sessionName) {
  return ValueKey("session-$index-of-$sessionName");
}

ValueKey getKeyForScoreIncrease(String playerName) {
  return ValueKey("scoreIncreaseForPlayer-$playerName");
}

ValueKey getKeyForScoreDecrease(String playerName) {
  return ValueKey("scoreDecreaseForPlayer-$playerName");
}

ValueKey getKeyForMatchChange(String matchName) {
  return ValueKey("matchChangeKeyForMatch-$matchName");
}

ValueKey getKeyForLeaderboardPlayerScore(String playerName) {
  return ValueKey('leaderboardScoreForPlayer-$playerName');
}

ValueKey getKeyForLeaderboardPlayerPosition(String playerName) {
  return ValueKey('leaderboardPositionForPlayer-$playerName');
}
