import 'dart:core';
import 'dart:math';

import 'package:friends_tournament/src/data/database/dao/match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/match_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_player_dao.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/setup_data_source.dart';
import 'package:friends_tournament/src/data/model/tournament/match.dart';
import 'package:friends_tournament/src/data/model/tournament/match_session.dart';
import 'package:friends_tournament/src/data/model/tournament/player.dart';
import 'package:friends_tournament/src/data/model/tournament/player_session.dart';
import 'package:friends_tournament/src/data/model/tournament/session.dart';
import 'package:friends_tournament/src/data/model/tournament/tournament.dart';
import 'package:friends_tournament/src/data/model/tournament/tournament_match.dart';
import 'package:friends_tournament/src/data/model/tournament/tournament_player.dart';
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

  DatabaseProvider databaseProvider = DatabaseProvider.get;
  var setupDataSource = SetupDataSource();

  Future setupTournament(
      int playersNumber,
      int playersAstNumber,
      int matchesNumber,
      String tournamentName,
      Map<int, String> playersName,
      Map<int, String> matchesName) async {
    this._playersNumber = playersNumber;
    this._playersAstNumber = playersAstNumber;
    this._matchesNumber = matchesNumber;
    this._tournamentName = tournamentName;

    this._tournament = Tournament(generateTournamentId(_tournamentName),
        _tournamentName, _playersNumber, _playersAstNumber, _matchesNumber, 1);

    _setupPlayers(playersName);
    _setupMatches(matchesName);
    _generateTournament();
    await _save();
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
    matchesName.forEach((index, matchName) {
      var matchId = generateMatchId(_tournamentName, matchName);
      var isActiveMatch = 0;
      if (index == 0 ) {
        isActiveMatch = 1;
      }
      var match = Match(matchId, matchName, isActiveMatch);
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
        var isActiveSession = 0;
        if (i == 0) {
          isActiveSession = 1;
        }
        var session = Session(sessionId, sessionName, isActiveSession);
        _sessions.add(session);
        var matchSession = MatchSession(match.id, sessionId);
        _matchSessionList.add(matchSession);
        var currentSessionPlayers = List<int>();
        for (int j = 0; j < _playersAstNumber; j++) {
          while (true) {
            int playerIndex = _random.nextInt(_playersNumber);
            if (currentSessionPlayers.contains(playerIndex)) {
              continue;
            } else {
              currentSessionPlayers.add(playerIndex);
              var player = _players[playerIndex];
              var playerSession = PlayerSession(player.id, sessionId, 0);
              _playerSessionList.add(playerSession);
              break;
            }
          }
        }
      }
    });
  }

  Future _save() async {

    await setupDataSource.createBatch();

    // TODO: add first a check to control if there is a current tournament active. Just for control

    // save tournament
    setupDataSource.insertToBatch(_tournament, TournamentDao());
    print(_tournament.toString());

    // save players
    var playerDao = PlayerDao();
    _players.forEach((player) {
      setupDataSource.insertIgnoreToBatch(player, playerDao);
      print(player.toString());
    });

    // save sessions
    var sessionDao = SessionDao();
    _sessions.forEach((session) {
      setupDataSource.insertToBatch(session, sessionDao);
      print(session.toString());
    });

    // save matches
    var matchDao = MatchDao();
    _matches.forEach((match) {
      setupDataSource.insertToBatch(match, matchDao);
      print(match.toString());
    });

    // save tournament player
    var tournamentPlayerDao = TournamentPlayerDao();
    _tournamentPlayerList.forEach((tournamentPlayer) {
      setupDataSource.insertToBatch(tournamentPlayer, tournamentPlayerDao);
      print(tournamentPlayer.toString());
    });

    // save player session
    var playerSessionDao = PlayerSessionDao();
    _playerSessionList.forEach((playerSession) {
      setupDataSource.insertToBatch(playerSession, playerSessionDao);
      print(playerSession.toString());
    });

    // save match session
    var matchSessionDao = MatchSessionDao();
    _matchSessionList.forEach((matchSession) {
      setupDataSource.insertToBatch(matchSession, matchSessionDao);
      print(matchSession.toString());
    });

    // save tournament match
    var tournamentMatchDao = TournamentMatchDao();
    _tournamentMatchList.forEach((tournamentMatch) {
      print(tournamentMatch.toString());
      setupDataSource.insertToBatch(tournamentMatch, tournamentMatchDao);
    });

    await setupDataSource.flushBatch();
  }

  Future<bool> isTournamentActive() async {
    var dao = TournamentDao();
    var tournament = await setupDataSource.getActiveTournament(dao);
    if (tournament != null) {
      return true;
    }
    return false;
  }

}
