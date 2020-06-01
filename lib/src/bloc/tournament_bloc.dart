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

import 'dart:async';

import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/model/app/ui_final_score.dart';
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
  final _leaderboardPlayersController = BehaviorSubject<List<UIPlayer>>();
  final _currentMatchNameController = BehaviorSubject<String>();

  // Input
  Sink<UIMatch> get setCurrentMatch => _updateCurrentMatchController.sink;

  Sink<PlayerSession> get setPlayerScore => _updatePlayerScoreController.sink;

  // Output
  Stream<Tournament> get activeTournament => _activeTournamentController.stream;

  Stream<List<UIMatch>> get tournamentMatches =>
      _tournamentMatchesController.stream;

  Stream<UIMatch> get currentMatch => _currentMatchController.stream;

  Stream<List<UIPlayer>> get leaderboardPlayers => _leaderboardPlayersController.stream;

  Stream<String> get currentMatchName => _currentMatchNameController.stream;

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
    _leaderboardPlayersController.close();
    _currentMatchNameController.close();
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

  static DatabaseProvider databaseProvider = DatabaseProviderImpl.get;
  static LocalDataSource localDataSource = LocalDataSource(databaseProvider);
  final repository = TournamentRepository(localDataSource);

  /// Retrieve the current active active tournament. Then fetches all the data
  /// required to show it to the user
  _fetchInitialData() {

    // TODO: add a try/catch and report the result on a stream. Maybe show "something is wrong" and return to the setup process

    // Current tournament
    repository.getCurrentActiveTournament().then((tournament) {
      _activeTournament = tournament;
      _fetchTournamentMatches(tournament);
    }).catchError((error) {
      print(error);
      // TODO: handle error?
    });
  }

  /// Retrieves the UI objects of the current tournament
  _fetchTournamentMatches(Tournament tournament) {

    // TODO: add a try/catch and report the result on a stream. Maybe show "something is wrong" and return to the setup process


    repository.getTournamentMatches(tournament.id).then((matchesList) {
      _tournamentMatches = matchesList;

      final currentMatch =
          _tournamentMatches.firstWhere((match) => match.isActive == 1);
      currentMatch.isSelected = true;
      _currentMatch = currentMatch;

      _computeLeaderboard();

      _activeTournamentController.add(_activeTournament);
      _tournamentMatchesController.add(_tournamentMatches);
      _currentMatchController.add(_currentMatch);
    }).catchError((error) {
      print(error);
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

    // TODO: add a try/catch and report the result on a stream. Maybe show "something is wrong" and return to the setup process


    // TODO: pay attention if we are not saving the current match


    // save the current progress on the database
    _currentMatch.isActive = 0;
    _currentMatch.isSelected = false;

    await repository.finishMatch(_currentMatch);

    _computeLeaderboard();

    // the current match is no active. Select another as active
    int currentMatchIndex = _tournamentMatches.indexOf(_currentMatch);
    // it could be the last match
    int nextMatchIndex = currentMatchIndex + 1;
    if (nextMatchIndex > _tournamentMatches.length - 1) {
      // we can finish the entire tournament
      // TODO: don't do this!! Notify something to the UI and then take the decision!
      await endTournament();
    } else {
      UIMatch nextMatch = _tournamentMatches[nextMatchIndex];
      nextMatch.isActive = 1;
      nextMatch.isSelected = true;
      await repository.updateMatch(nextMatch);
      _currentMatch = nextMatch;
      _currentMatchController.add(_currentMatch);
      _tournamentMatchesController.add(_tournamentMatches);
      _currentMatchNameController.add(_currentMatch.name);

    }
  }

  Future<void> endTournament() async {

    // TODO: add a try/catch and report the result on a stream. Maybe show "something is wrong" and return to the setup process

    final List<UIScore> finalScores =
        await repository.finishTournament(_activeTournament);

    // TODO: decide what to do!
    print(finalScores);

    return;
  }

  void _computeLeaderboard() async {

    // TODO: add a try/catch and report the result on a stream. Maybe show "something is wrong" and return to the setup process

    final List<UIScore> scores = await repository.getScore(_activeTournament);

    List<UIPlayer> players =
        scores.map((uiScore) => UIPlayer(id: uiScore.id, name: uiScore.name, score: uiScore.score)).toList();

    _leaderboardPlayersController.add(players);

  }
}
