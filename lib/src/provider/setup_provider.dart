import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/utils/error_reporting.dart';
import 'package:friends_tournament/src/utils/service_locator.dart';

class SetupProvider with ChangeNotifier {
  /// The min value for a meaningful tournament is two players
  int _playersNumber = 2;
  int get playersAstNumber => _playersAstNumber;

  /// The min value for a meaningful match is two players
  int _playersAstNumber = 2;
  int get playersNumber => _playersNumber;

  /// The min value for a meaningful tournament is one
  int _matchesNumber = 1;
  int get matchesNumber => _matchesNumber;

  late String _tournamentName;

  Map<int, String> _playersName = {};
  UnmodifiableMapView<int, String> get playersName =>
      UnmodifiableMapView(_playersName);

  Map<int, String> _matchesName = {};
  UnmodifiableMapView<int, String> get matchesName => UnmodifiableMapView(_matchesName);

  void setPlayersNumber(int value) {
    _playersNumber = value;
    notifyListeners();
  }

  void setPlayersAstNumber(int value) {
    _playersAstNumber = value;
    notifyListeners();
  }

  void setMatchesNumber(int value) {
    _matchesNumber = value;
    notifyListeners();
  }

  void setTournamentName(String value) {
    _tournamentName = value;
  }

  void setPlayersName(Map<int, String> value) {
    _playersName = value;
  }

  void setMatchesName(Map<int, String> value) {
    _matchesName = value;
  }

  Future<bool> setupTournament() async {
    try {
      await setupRepository.setupTournament(_playersNumber, _playersAstNumber,
          _matchesNumber, _tournamentName, _playersName, _matchesName);
      return true;
    } catch (error, stackTrace) {
      /// We know these exceptions:
      ///  - MatchesWithSameIdException
      ///  - TooMuchPlayersASTException -> do not start setup process from scratch
      ///  - AlreadyActiveTournamentException -> it should never happen! A setup process never starts if there is another ongoing tournament
      await reportError(error, stackTrace, "Error during tournament setup");
      notifyListeners();
      return false;
    }
  }
}
