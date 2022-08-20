import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:friends_tournament/src/data/model/app/ui_final_score.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/utils/error_reporting.dart';
import 'package:friends_tournament/src/utils/service_locator.dart';

class LeaderboardProvider with ChangeNotifier {
  LeaderboardProvider(Tournament tournament) {
    _computeLeaderboard(tournament);
  }

  String? _tournamentName = "";
  String? get tournamentName => _tournamentName;

  List<UIPlayer> _leaderboardPlayers = [];
  UnmodifiableListView<UIPlayer> get leaderboardPlayers =>
      UnmodifiableListView(_leaderboardPlayers);

  bool _showError = false;
  bool get showError => _showError;

  void _computeLeaderboard(Tournament tournament) async {
    try {
      final List<UIScore> scores = await tournamentRepository.getScore(
        tournament,
      );

      List<UIPlayer> players = scores
          .map((uiScore) => UIPlayer(
                id: uiScore.id,
                name: uiScore.name,
                score: uiScore.score,
              ))
          .toList();

      _leaderboardPlayers = players;
      _tournamentName = tournament.name;
      notifyListeners();
    } catch (error, stackTrace) {
      await reportError(
        error,
        stackTrace,
        "Error while computing the leaderboard",
      );
      _showError = true;
      notifyListeners();
    }
  }

  void resetErrorFlag() {
    _showError = false;
  }
}
