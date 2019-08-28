import 'package:friends_tournament/src/data/database/dao/tournament_player_dao.dart';

/// The player of a specific tournament
/// Correspond to a row of the 'tournament_player' db table. [TournamentPlayerDao]
class TournamentPlayer {
  String playerId;
  String tournamentId;
  int finalScore;

  TournamentPlayer(this.playerId, this.tournamentId, this.finalScore);

  @override
  String toString() {
    return 'TournamentPlayer{playerId: $playerId, tournamentId: $tournamentId, finalScore: $finalScore}';
  }
}
