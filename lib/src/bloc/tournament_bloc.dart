import 'dart:async';

import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/player_session.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:rxdart/rxdart.dart';

class TournamentBloc {
  /* *************
  *
  * Stream Stuff
  *
  * ************** */

  // Controllers of input and output

  final _activeTournamentController = BehaviorSubject<Tournament>();
  final _tournamentMatchesController = BehaviorSubject<List<UIMatch>>();
  final _currentMatchController = BehaviorSubject<UIMatch>();
  final _updateCurrentMatchController = BehaviorSubject<UIMatch>();
  final _updatePlayerScoreController = StreamController<PlayerSession>();

  // Input
  Sink<UIMatch> get setCurrentMatch => _updateCurrentMatchController.sink;

  Sink<PlayerSession> get setPlayerScore => _updatePlayerScoreController.sink;

  // Output
  Stream<Tournament> get activeTournament => _activeTournamentController.stream;

  Stream<List<UIMatch>> get tournamentMatches =>
      _tournamentMatchesController.stream;

  Stream<UIMatch> get currentMatch => _currentMatchController.stream;

  /* *************
  *
  * Constructor/Destructor
  *
  * ************** */
  TournamentBloc() {
    _updateCurrentMatchController.stream.listen(_setCurrentMatch);
    _updatePlayerScoreController.stream.listen(_setPlayerScore);
    _fetchInitialData();
  }

  // TODO: add the dispose
  void dispose() {
    _activeTournamentController.close();
    _tournamentMatchesController.close();
    _currentMatchController.close();
    _updateCurrentMatchController.close();
    _updatePlayerScoreController.close();
  }

  /* *************
  *
  * Status Variables
  *
  * ************** */
  Tournament _activeTournament;

  /// A list of all the matches the composes the actual tournament.
  /// When the user select a specific match, we filter it from the list, save
  /// on the [] variable and return it to the UI using the [] stream.
  List<UIMatch> _tournamentMatches;

  /// The match that is actually selected and visible in the UI.
  UIMatch _currentMatch;

  final repository = TournamentRepository();

  _fetchInitialData() {
    // Current tournament
    repository.getCurrentActiveTournament().then((tournament) {
      _activeTournament = tournament;
      _fetchTournamentMatches(tournament);
    }).catchError((error) {
      print(error);
      // TODO: handle error?
    });
  }

  _fetchTournamentMatches(Tournament tournament) {
    repository.getTournamentMatches(tournament.id).then((matchesList) {
      _tournamentMatches = matchesList;

      final currentMatch =
          _tournamentMatches.firstWhere((match) => match.isActive == 1);
      currentMatch.isSelected = true;
      _currentMatch = currentMatch;

      _activeTournamentController.add(_activeTournament);
      _tournamentMatchesController.add(_tournamentMatches);
      _currentMatchController.add(_currentMatch);
    }).catchError((error) {
      print(error);
      // TODO: handle error?
    });
  }

  _setCurrentMatch(UIMatch match) {
    match.isSelected = true;
    _currentMatch.isSelected = false;
    _currentMatch = match;
    _currentMatchController.add(_currentMatch);
    _tournamentMatchesController.add(_tournamentMatches);
  }

  _setPlayerScore(PlayerSession playerSession) {
    UISession session = _currentMatch.matchSessions
        .firstWhere((session) => session.id == playerSession.sessionId);

    UIPlayer player = session.sessionPlayers
        .firstWhere((player) => player.id == playerSession.playerId);

    player.score = playerSession.score;

    _currentMatchController.add(_currentMatch);
    _tournamentMatchesController.add(_tournamentMatches);
  }



}
