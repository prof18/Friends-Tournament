class TournamentMatch {
  String tournamentId;
  String matchId;

  TournamentMatch(this.tournamentId, this.matchId);

  @override
  String toString() {
    return 'TournamentMatch{tournamentId: $tournamentId, matchId: $matchId}';
  }


}