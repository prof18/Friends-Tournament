import 'dart:math';

import 'package:friends_tournament/src/data/model/match.dart';
import 'package:friends_tournament/src/data/model/match_session.dart';
import 'package:friends_tournament/src/data/model/player.dart';
import 'package:friends_tournament/src/data/model/player_session.dart';
import 'package:friends_tournament/src/data/model/session.dart';
import 'package:friends_tournament/src/data/model/tournament.dart';
import 'package:friends_tournament/src/data/model/tournament_match.dart';
import 'package:friends_tournament/src/data/model/tournament_player.dart';
import 'package:friends_tournament/src/utils/id_generator.dart';

class SetupRepository {
  // Implement singleton
  // To get back it, simple call: MyClass myObj = new MyClass();
  /// -------
  static final SetupRepository _singleton = new SetupRepository._internal();

  factory SetupRepository() {
    return _singleton;
  }

  SetupRepository._internal();

  /// -------

  final _random = new Random();

  /* *************
  *
  * Internal Variables
  *
  * ************** */

  List<Player> _players = List<Player>();
  List<Session> _sessions = List<Session>();
  List<Match> _matches = List<Match>();
  List<PlayerSession> _playerSessionList = List<PlayerSession>();
  List<MatchSession> _matchSessionList = List<MatchSession>();
  List<TournamentMatch> _tournamentMatchList = List<TournamentMatch>();
  List<TournamentPlayer> _tournamentPlayerList = List<TournamentPlayer>();

  Tournament _tournament;

  int _playersNumber;
  int _playersAstNumber;
  int _matchesNumber;
  String _tournamentName;

  void setupTournament(
      int playersNumber,
      int playersAstNumber,
      int matchesNumber,
      String tournamentName,
      Map<int, String> playersName,
      Map<int, String> matchesName) {
    this._playersNumber = playersNumber;
    this._playersAstNumber = playersAstNumber;
    this._matchesNumber = matchesNumber;
    this._tournamentName = tournamentName;

    this._tournament = Tournament(generateTournamentId(_tournamentName),
        _tournamentName, _playersNumber, _playersAstNumber, _matchesNumber);

    _setupPlayers(playersName);
    _setupMatches(matchesName);
    _generateTournament();
    _saveOnDB();
  }

  void _setupPlayers(Map<int, String> playersName) {
    playersName.forEach((_, playerName) {
      var playerId = generatePlayerId(playerName);
      var player = Player(playerId, playerName);
      _players.add(player);
      var tournamentPlayer = TournamentPlayer(playerId, _tournament.id, 0);
      _tournamentPlayerList.add(tournamentPlayer);
    });
  }

  void _setupMatches(Map<int, String> matchesName) {
    matchesName.forEach((_, matchName) {
      var matchId = generateMatchId(_tournamentName, matchName);
      var match = Match(matchId, matchName);
      if (_matches.contains(match)) {
        throw Exception("Two matches has the same name");
      } else {
        _matches.add(match);
        var tournamentMatch = TournamentMatch(_tournament.id, matchId);
        _tournamentMatchList.add(tournamentMatch);
      }
    });
  }

  void _generateTournament() {
    _matches.forEach((match) {
      // number of sessions for the same match
      int sessions = (_matchesNumber / _playersAstNumber).ceil();
      for (int i = 0; i < sessions; i++) {
        var sessionName = "Session-$i";
        var sessionId = generateSessionId(match.id, sessionName);
        var session = Session(sessionId, sessionName);
        _sessions.add(session);
        var currentSessionPlayers = List<int>();
        for (int j = 0; j < _playersAstNumber; j++) {
          while (true) {
            int playerIndex = _random.nextInt(_playersNumber + 1);
            if (currentSessionPlayers.contains(playerIndex)) {
              continue;
            } else {
              currentSessionPlayers.add(playerIndex);
              var player = _players[playerIndex];
              var playerSession = PlayerSession(player.id, sessionId, 0);
              _playerSessionList.add(playerSession);
              var matchSession = MatchSession(match.id, sessionId);
              _matchSessionList.add(matchSession);
              break;
            }
          }
        }
      }
    });
  }

  void _saveOnDB() {

  }
}
