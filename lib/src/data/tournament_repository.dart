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

import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/model/app/ui_final_score.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/match.dart' as tournament;
import 'package:friends_tournament/src/data/model/db/player_session.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/data/model/db/tournament_player.dart';

class TournamentRepository {
  // Implement singleton
  // To get back it, simple call: MyClass myObj = new MyClass();
  /// -------
  static final TournamentRepository _singleton =
      new TournamentRepository._internal();

  LocalDataSource localDataSource;

  factory TournamentRepository(LocalDataSource localDataSource) {
    _singleton.localDataSource = localDataSource;
    return _singleton;
  }

  TournamentRepository._internal();

  /// -------

  Future<bool> isTournamentActive() async {
    final dao = TournamentDao();
    final tournament = await localDataSource.getActiveTournament(dao);
    if (tournament != null) {
      return true;
    }
    return false;
  }

  Future<Tournament> getLastFinishedTournament() async {
    return localDataSource.getLastTournament();
  }

  Future<Tournament> getCurrentActiveTournament() async {
    final dao = TournamentDao();
    final tournament = await localDataSource.getActiveTournament(dao);
    return tournament;
  }

  /// Retrieve the tournament data from the database and prepare the data for the UI
  Future<List<UIMatch>> getTournamentMatches(String tournamentID) async {
    // Query to get the matches
    final List<Map> dbMatches =
        await localDataSource.getTournamentMatches(tournamentID);

    // For each match, query to get the different sessions
    List<UIMatch> uiMatchList = List<UIMatch>();

    await Future.forEach(dbMatches.toList(), (row) async {
      final String idMatch = row['id_match'];
      final String matchName = row['name'];
      final int isActive = row['is_active'];
      final int matchOrder = row['match_order'];

      final List<Map> dbMatchSessions =
          await localDataSource.getMatchSessions(idMatch);

      // For each session, get the players
      List<UISession> uiSessionList = List<UISession>();

      await Future.forEach(dbMatchSessions.toList(), (row) async {
        final idSession = row['id_session'];
        final sessionName = row['name'];
        final order = row['session_order'];

        final List<Map> dbPlayers =
            await localDataSource.getSessionPlayers(idSession);

        // create the UIPlayerObject
        List<UIPlayer> uiPlayerList = List<UIPlayer>();

        await Future.forEach(dbPlayers.toList(), (row) async {
          final idPlayer = row['player_id'];
          final playerName = row['player_name'];
          final playerScore = row['player_score'];

          UIPlayer player = UIPlayer(
            id: idPlayer,
            name: playerName,
            score: playerScore,
          );
          uiPlayerList.add(player);
        });

        UISession uiSession = UISession(
          id: idSession,
          name: sessionName,
          order: order,
          sessionPlayers: uiPlayerList,
        );
        uiSessionList.add(uiSession);
      });

      UIMatch uiMatch = UIMatch(
          id: idMatch,
          name: matchName,
          isActive: isActive,
          matchSessions: uiSessionList,
          order: matchOrder);
      uiMatchList.add(uiMatch);
    });
    return uiMatchList;
  }

  /// This methods finish a match, i.e. perform an update on the
  /// state of the tournament.
  /// The tables the must updated are the following:
  ///   - matches -> is_active
  ///   - player_session -> score
  ///   - tournament_player -> final_score
  Future<void> finishMatch(UIMatch uiMatch, Tournament tournament) async {
    // put inactive the current match
    final match = uiMatch.getParent();
    await localDataSource.updateMatch(match);

    // update the scores of the player
    await Future.forEach(uiMatch.matchSessions, (session) async {
      print("Session: ${session.toString()}");
      // loop through the players
      await Future.forEach(session.sessionPlayers, (player) async {
        print("Player: ${player.toString()}");
        final PlayerSession playerSession =
            PlayerSession(player.id, session.id, player.score);
        await localDataSource.updatePlayerSession(playerSession);

        final tournamentPlayer = await getTournamentPlayer(player.id, tournament.id);
        if (tournamentPlayer != null) {
          tournamentPlayer.finalScore += player.score;
          await localDataSource.updateTournamentPlayer(tournamentPlayer);
        }
      });
    });

    return;
  }


  Future<TournamentPlayer> getTournamentPlayer(String playerId, String tournamentId) async{
    final players = await localDataSource.getTournamentPlayers(tournamentId);
    return players.firstWhere((element) => element.playerId == playerId, orElse: null);
  }


  Future<List<UIScore>> getScore(Tournament tournament) async {
    final List<Map> results = await localDataSource.getTournamentScore(tournament.id);
    final List<UIScore> finalScores = List<UIScore>();
    await Future.forEach(results, (row) async {
      final idPlayer = row['id_player'];
      final finalScore = row['final_score'];
      final playerName = row['name'];
      finalScores.add(
        UIScore(
          id: idPlayer,
          name: playerName,
          score: finalScore,
        ),
      );
    });
    return finalScores;
  }

  Future<void> finishTournament(Tournament tournament) async {
    tournament.isActive = 0;
    await localDataSource.updateTournament(tournament);
  }

  Future<void> updateMatch(UIMatch uiMatch) async {
    // put inactive the current match
    final tournament.Match match = uiMatch.getParent();
    await localDataSource.updateMatch(match);
    return;
  }

  /// Used to fix eventual errors
  Future<void> finishAllTournament() async {
    List<Tournament> allTournaments = await localDataSource.getAllTournaments();
    Future.forEach(allTournaments, (tournament) async {
      tournament.isActive = 0;
      await localDataSource.updateTournament(tournament);
    });
  }
}
