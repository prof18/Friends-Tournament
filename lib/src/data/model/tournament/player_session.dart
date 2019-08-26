/// The player of a specific sessions
class PlayerSession {
  String playerId;
  String sessionId;
  int score;

  PlayerSession(this.playerId, this.sessionId, this.score);

  @override
  String toString() {
    return 'PlayerSession{playerId: $playerId, sessionId: $sessionId, score: $score}';
  }
}
