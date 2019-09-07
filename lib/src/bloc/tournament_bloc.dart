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
  final _podiumPlayersController = BehaviorSubject<List<UIPlayer>>();

  // Input
  Sink<UIMatch> get setCurrentMatch => _updateCurrentMatchController.sink;

  Sink<PlayerSession> get setPlayerScore => _updatePlayerScoreController.sink;

  // Output
  Stream<Tournament> get activeTournament => _activeTournamentController.stream;

  Stream<List<UIMatch>> get tournamentMatches =>
      _tournamentMatchesController.stream;

  Stream<UIMatch> get currentMatch => _currentMatchController.stream;

  Stream<List<UIPlayer>> get podiumPlayers => _podiumPlayersController.stream;

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

  void dispose() {
    _activeTournamentController.close();
    _tournamentMatchesController.close();
    _currentMatchController.close();
    _updateCurrentMatchController.close();
    _updatePlayerScoreController.close();
    _podiumPlayersController.close();
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

      _computeTempPodium();

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

  Future<void> endMatch() async {
    // save the current progress on the database
    _currentMatch.isActive = 0;
    _currentMatch.isSelected = false;

    await repository.finishMatch(_currentMatch);

    // TODO: compute the temporary podium
    _computeTempPodium();

    // the current match is no active. Select another as active
    int currentMatchIndex = _tournamentMatches.indexOf(_currentMatch);
    // it could be the last match
    int nextMatchIndex = currentMatchIndex + 1;
    if (nextMatchIndex > _tournamentMatches.length - 1) {
      // we can finish the entire tournament
      _endTournament();
    } else {
      UIMatch nextMatch = _tournamentMatches[nextMatchIndex];
      nextMatch.isActive = 1;
      nextMatch.isSelected = true;
      await repository.updateMatch(nextMatch);
      _currentMatch = nextMatch;
      _currentMatchController.add(_currentMatch);
      _tournamentMatchesController.add(_tournamentMatches);
    }
  }

  _endTournament() {
    // TODO
    throw UnimplementedError();
  }

  void _computeTempPodium() {
    List<UIPlayer> players = List<UIPlayer>();

    _currentMatch.matchSessions.forEach((session) {
      players.addAll(session.sessionPlayers);
    });

    players.sort((a, b) => a.score.compareTo(b.score));
    players = players.reversed.toList().take(3).toList();

    if (players.length == 3 &&
        players[0].score == 0 &&
        players[1].score == 0 &&
        players[2].score == 0) {
      _podiumPlayersController.add(List<UIPlayer>());
    } else {
      _podiumPlayersController.add(players);
    }
  }
}
