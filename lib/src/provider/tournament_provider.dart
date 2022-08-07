import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:friends_tournament/src/data/model/app/end_match_result.dart';
import 'package:friends_tournament/src/data/model/app/end_tournament_result.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/player_session.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/utils/error_reporting.dart';
import 'package:friends_tournament/src/utils/service_locator.dart';

class TournamentProvider with ChangeNotifier {
  Tournament _activeTournament;
  Tournament get activeTournament => _activeTournament;

  /// A list of all the matches the composes the actual tournament.
  /// When the user select a specific match, we filter it from the list, save
  /// on the [] variable and return it to the UI using the [] stream.
  List<UIMatch> _tournamentMatches = [];
  UnmodifiableListView<UIMatch> get tournamentMatches =>
      UnmodifiableListView(_tournamentMatches);

  /// The match that is actually selected and visible in the UI.
  UIMatch _currentMatch;
  UIMatch get currentMatch => _currentMatch;

  bool _showTournamentInitError = false;
  bool get showTournamentInitError => _showTournamentInitError;

  TournamentProvider() {
    _fetchInitialData();
  }

  /// Retrieve the current active active tournament. Then fetches all the data
  /// required to show it to the user
  _fetchInitialData() async {
    try {
      final tournament = await tournamentRepository.getCurrentActiveTournament();
      _activeTournament = tournament;
      if (tournament != null) {
        _fetchTournamentMatches(tournament);
      }
    } catch (error, stackTrace) {
      await reportError(error, stackTrace);
      _showTournamentInitError = true;
      notifyListeners();
    }
  }

  /// Retrieves the UI objects of the current tournament
  _fetchTournamentMatches(Tournament tournament) async {
    try {
      List<UIMatch> matchesList = await tournamentRepository.getTournamentMatches(tournament.id);
      _tournamentMatches = matchesList;

      // If all the matches are not active, we set as first match the first one
      final currentMatch = _tournamentMatches.firstWhere(
          (match) => match.isActive == 1,
          orElse: () => _tournamentMatches[0]);

      currentMatch.isSelected = true;
      _currentMatch = currentMatch;
      notifyListeners();
    } catch (error, stackTrace) {
      await reportError(error, stackTrace);
      _showTournamentInitError = true;
      notifyListeners();
    }
  }

  setCurrentMatch(UIMatch match) {
    match.isSelected = true;
    _currentMatch.isSelected = false;
    _currentMatch = match;
    notifyListeners();
  }

  setPlayerScore(PlayerSession playerSession) {
    UISession session = _currentMatch.matchSessions
        .firstWhere((session) => session.id == playerSession.sessionId);

    UIPlayer player = session.sessionPlayers
        .firstWhere((player) => player.id == playerSession.playerId);

    player.score = playerSession.score;

    notifyListeners();
  }

  Future<EndMatchStatus> endMatch() async {
    try {
      // save the current progress on the database
      _currentMatch.isActive = 0;
      _currentMatch.isSelected = false;

      await tournamentRepository.finishMatch(_currentMatch, _activeTournament);

      // the current match is no active. Select another as active
      int currentMatchIndex = _tournamentMatches.indexOf(_currentMatch);
      // it could be the last match
      int nextMatchIndex = currentMatchIndex + 1;
      if (nextMatchIndex > _tournamentMatches.length - 1) {
        // we can finish the entire tournament. So notify the fact to the UI.
        notifyListeners();
        return EndMatchStatus.end_tournament;
      } else {
        UIMatch nextMatch = _tournamentMatches[nextMatchIndex];
        nextMatch.isActive = 1;
        nextMatch.isSelected = true;
        await tournamentRepository.updateMatch(nextMatch);
        _currentMatch = nextMatch;
        notifyListeners();
        return EndMatchStatus.next_match;
      }
    } catch (error, stackTrace) {
      await reportError(error, stackTrace);
      return EndMatchStatus.error;
    }
  }

  Future<EndTournamentResult> endTournament() async {
    try {
      await tournamentRepository.finishTournament(_activeTournament);
      return EndTournamentResult.success;
    } catch (error, stackTrace) {
      await reportError(error, stackTrace);
      return EndTournamentResult.error;
    }
  }

  void resetErrorTrigger() {
    _showTournamentInitError = false;
  }
}
