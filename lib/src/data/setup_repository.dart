/*
 * Copyright 2019 Marco Gomiero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/database/dao/match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/match_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_dao.dart';
import 'package:friends_tournament/src/data/database/dao/player_session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/session_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_match_dao.dart';
import 'package:friends_tournament/src/data/database/dao/tournament_player_dao.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/model/db/match.dart';
import 'package:friends_tournament/src/data/model/db/match_session.dart';
import 'package:friends_tournament/src/data/model/db/player.dart';
import 'package:friends_tournament/src/data/model/db/player_session.dart';
import 'package:friends_tournament/src/data/model/db/session.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/data/model/db/tournament_match.dart';
import 'package:friends_tournament/src/data/model/db/tournament_player.dart';
import 'package:friends_tournament/src/utils/id_generator.dart';

import 'errors.dart';

class SetupRepository {
  late LocalDataSource localDataSource;

  SetupRepository(this.localDataSource);

  /// -------

  final _random = Random();

  /* *************
  *
  * Internal Variables
  *
  * ************** */
  @visibleForTesting
  List<Player> players = <Player>[];
  @visibleForTesting
  List<Session> sessions = <Session>[];
  @visibleForTesting
  List<Match> matches = <Match>[];
  @visibleForTesting
  List<PlayerSession> playerSessionList = <PlayerSession>[];
  @visibleForTesting
  List<MatchSession> matchSessionList = <MatchSession>[];
  List<TournamentMatch> _tournamentMatchList = <TournamentMatch>[];
  List<TournamentPlayer> _tournamentPlayerList = <TournamentPlayer>[];

  late Tournament _tournament;

  late int _playersNumber;
  late int _playersAstNumber;
  late int _matchesNumber;
  late String _tournamentName;

  Future setupTournament(
    int playersNumber,
    int playersAstNumber,
    int matchesNumber,
    String tournamentName,
    Map<int, String> playersName,
    Map<int, String> matchesName,
  ) async {
    createTournament(
      playersNumber,
      playersAstNumber,
      matchesNumber,
      tournamentName,
      playersName,
      matchesName,
    );
    await save();
    players = [];
    sessions = [];
    matches = [];
    playerSessionList = [];
    matchSessionList = [];
    _tournamentMatchList = [];
    _tournamentPlayerList = [];
  }

  ///
  /// A Tournament is composed of matches. Every match can be composed of one
  /// or multiple sessions. This because only a specified number of players can
  /// play at the same time.
  ///
  /// Create a new tournament starting the following parameters:
  ///
  /// - [playersNumber]     -> The total number of players of the tournament
  /// - [playersAstNumber]  -> The number of player that can play in the same time
  /// - [matchesNumber]     -> The number of matches which the tournament is composed
  /// - [tournamentName]    -> The name of the tournament
  /// - [playersName]       -> The name of the tournament's player
  /// - [matchesName]       -> The name of the matches which the tournament is composed
  ///
  void createTournament(
      int playersNumber,
      int playersAstNumber,
      int matchesNumber,
      String tournamentName,
      Map<int, String> playersName,
      Map<int, String> matchesName) {
    if (playersAstNumber > playersNumber) {
      // should never happen!
      throw TooMuchPlayersASTException();
    }

    _playersNumber = playersNumber;
    _playersAstNumber = playersAstNumber;
    _matchesNumber = matchesNumber;
    _tournamentName = tournamentName;

    debugPrint("*** Starting Tournament Generation");
    debugPrint("Players number -> $playersNumber");
    debugPrint("Players ast number -> $playersAstNumber");
    debugPrint("Matches number -> $matchesNumber");
    debugPrint("Tournament Name -> $tournamentName");
    debugPrint("players Name -> $playersName");
    debugPrint("matches name -> $matchesName");

    _tournament = Tournament(
      generateTournamentId(_tournamentName),
      _tournamentName,
      _playersNumber,
      _playersAstNumber,
      _matchesNumber,
      1,
      DateTime.now().millisecondsSinceEpoch,
    );

    _setupPlayers(playersName);
    _setupMatches(matchesName);
    _generateTournament();
  }

  ///
  /// For each player, a [Player] object is created and stored in [players], with a unique id generated
  /// by [generatePlayerId].
  ///
  /// Next, an association between the [Player] and the [Tournament] is created
  /// by using the object [TournamentPlayer] that are stored in the [_tournamentPlayerList]
  ///
  void _setupPlayers(Map<int, String> playersName) {
    playersName.forEach((_, playerName) {
      var playerId = generatePlayerId(playerName);
      var player = Player(playerId, playerName);
      players.add(player);
      var tournamentPlayer = TournamentPlayer(playerId, _tournament.id, 0);
      _tournamentPlayerList.add(tournamentPlayer);
    });
  }

  ///
  /// For each match, a [Match] object is created and stored in [matches], with a
  /// unique id generated by [generateMatchId]. Only the first match is selected
  /// as active, the other one are inactive. That's because we can play one match a time.
  ///
  /// Next, an association between the [Match] and the [Tournament] is created by
  /// using the object [TournamentMatch] and stored in the [_tournamentMatchList]
  ///
  void _setupMatches(Map<int, String> matchesName) {
    matchesName.forEach((index, matchName) {
      var matchId = generateMatchId(_tournament.id, matchName);
      var isActiveMatch = 0;
      if (index == 0) {
        isActiveMatch = 1;
      }
      var match = Match(matchId, matchName, isActiveMatch, index);
      if (matches.contains(match)) {
        throw MatchesWithSameIdException();
      } else {
        matches.add(match);
        var tournamentMatch = TournamentMatch(_tournament.id, matchId);
        _tournamentMatchList.add(tournamentMatch);
      }
    });
  }

  ///
  /// For each match store in [matches], the number of sessions is computed. The
  /// computation is the division between the number of matches and the number of
  /// players that can play at the same time.
  ///
  /// For each session, a [Session] object is created and stored in the [sessions] list.
  /// Next, an association between the [Match] and the [Session] is created by using
  /// the [MatchSession] object.
  ///
  /// Now we need to assign the player to a specific session. For doing this, a
  /// random index is extracted and a candidate is extracted from the [players] list.
  /// The selected players are stored in the [currentSessionPlayers] list. The extraction
  /// continue as soon a valid index is extracted. The association between the [Player]
  /// and the [Session] is saved in the [playerSessionList]
  ///
  void _generateTournament() {
    for (var match in matches) {
      // number of sessions for the same match
      int sessionsNumber = (_playersNumber / _playersAstNumber).ceil();
      var playersForSession = List.from(players);
      for (int i = 0; i < sessionsNumber; i++) {
        var sessionName = "Round ${i + 1}";
        var sessionId = generateSessionId(match.id, sessionName);
        var session = Session(sessionId, sessionName, i);
        sessions.add(session);
        var matchSession = MatchSession(match.id, sessionId);
        matchSessionList.add(matchSession);

        final limit = min(_playersAstNumber, playersForSession.length);
        for (int j = 0; j < limit; j++) {
          int playerIndex = _random.nextInt(playersForSession.length);
          final playerCandidate = playersForSession[playerIndex];
          debugPrint(
            "Adding Player: ${playerCandidate.name} to session: $sessionName",
          );
          playersForSession.removeAt(playerIndex);
          var playerSession = PlayerSession(
            playerCandidate.id,
            sessionId,
            0,
          );
          playerSessionList.add(playerSession);
        }
      }
    }
  }

  @visibleForTesting
  Future save() async {
    debugPrint("Launching the save process");

    final dao = TournamentDao();
    final tournament = await localDataSource.getActiveTournament(dao);
    if (tournament != null) {
      // There is an active tournament that should not be there!
      throw AlreadyActiveTournamentException();
    }

    await localDataSource.createBatch();

    // save tournament
    localDataSource.insertToBatch(_tournament, TournamentDao());
    debugPrint(_tournament.toString());

    var playerDao = PlayerDao();
    for (var player in players) {
      localDataSource.insertIgnoreToBatch(player, playerDao);
      debugPrint(player.toString());
    }

    // save sessions
    var sessionDao = SessionDao();
    for (var session in sessions) {
      localDataSource.insertToBatch(session, sessionDao);
      debugPrint(session.toString());
    }

    // save matches
    var matchDao = MatchDao();
    for (var match in matches) {
      localDataSource.insertToBatch(match, matchDao);
      debugPrint(match.toString());
    }

    // save tournament player
    var tournamentPlayerDao = TournamentPlayerDao();
    for (var tournamentPlayer in _tournamentPlayerList) {
      localDataSource.insertToBatch(tournamentPlayer, tournamentPlayerDao);
      debugPrint(tournamentPlayer.toString());
    }

    // save player session
    var playerSessionDao = PlayerSessionDao();
    for (var playerSession in playerSessionList) {
      localDataSource.insertToBatch(playerSession, playerSessionDao);
      debugPrint(playerSession.toString());
    }

    // save match session
    var matchSessionDao = MatchSessionDao();
    for (var matchSession in matchSessionList) {
      localDataSource.insertToBatch(matchSession, matchSessionDao);
      debugPrint(matchSession.toString());
    }

    // save tournament match
    var tournamentMatchDao = TournamentMatchDao();
    for (var tournamentMatch in _tournamentMatchList) {
      debugPrint(tournamentMatch.toString());
      localDataSource.insertToBatch(tournamentMatch, tournamentMatchDao);
    }

    await localDataSource.flushBatch();
  }
}
