import 'package:flutter/widgets.dart';

const setupNextButtonKey = ValueKey('nextSetupButton');
const setupBackButtonKey = ValueKey('backSetupButton');

const counterWidgetPlusButton = ValueKey("counterWidgetPlusButton");
const counterWidgetMinusButton = ValueKey("counterWidgetMinusButton");

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

const finishSetupProceedButtonKey = ValueKey("setupPopupProceedButton");

const matchViewButtonKey = ValueKey('matchViewButton');