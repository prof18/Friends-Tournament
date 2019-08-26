/// The player of a specific tournament
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
