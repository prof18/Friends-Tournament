import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';
import 'package:friends_tournament/src/data/database/db_data_source.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';

class TournamentRepository {
  // Implement singleton
  // To get back it, simple call: MyClass myObj = new MyClass();
  /// -------
  static final TournamentRepository _singleton =
      new TournamentRepository._internal();

  factory TournamentRepository() {
    return _singleton;
  }

  TournamentRepository._internal();

  /// -------

  var dbDataSource = DBDataSource();

  Future<bool> isTournamentActive() async {
    final dao = TournamentDao();
    final tournament = await dbDataSource.getActiveTournament(dao);
    if (tournament != null) {
      return true;
    }
    return false;
  }

  Future<Tournament> getCurrentActiveTournament() async {
    final dao = TournamentDao();
    final tournament = await dbDataSource.getActiveTournament(dao);
    return tournament;
  }

  Future<List<UIMatch>> getTournamentMatches(String tournamentID) async {
    // Query to get the matches
    final List<Map> dbMatches =
        await dbDataSource.getTournamentMatches(tournamentID);

    // For each match, query to get the different sessions
    List<UIMatch> uiMatchList = List<UIMatch>();

    await Future.forEach(dbMatches.toList(), (row) async {

      // TODO: change this
      final String idMatch = row['id_match'];
      final String matchName = row['name'];
      final int isActive = row['is_active'];

      final List<Map> dbMatchSessions =
          await dbDataSource.getMatchSessions(idMatch);

      // For each session, get the players
      List<UISession> uiSessionList = List<UISession>();

      await Future.forEach(dbMatchSessions.toList(), (row) async {
        final idSession = row['id_session'];
        final sessionName = row['name'];
        final order = row['order'];

        final List<Map> dbPlayers =
            await dbDataSource.getSessionPlayers(idSession);

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
      );
      uiMatchList.add(uiMatch);
    });
    return uiMatchList;
  }

  /// This methods perform an update on the state of the tournament.
  /// The tables the must updated are the following:
  ///   - matches -> is_active
  ///   - player_session -> score
  ///   - tournament_player -> final_score
  Future<void> updateTournamentStatus(UIMatch uiMatch) async {

  }
}
