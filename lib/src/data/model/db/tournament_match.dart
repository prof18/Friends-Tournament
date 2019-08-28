import 'package:friends_tournament/src/data/database/dao/tournament_match_dao.dart';

/// The match of a specific tournament
/// Correspond to a row of the 'tournament_match' db table. [TournamentMatchDao]
class TournamentMatch {
  String tournamentId;
  String matchId;

  TournamentMatch(this.tournamentId, this.matchId);

  @override
  String toString() {
    return 'TournamentMatch{tournamentId: $tournamentId, matchId: $matchId}';
  }


}