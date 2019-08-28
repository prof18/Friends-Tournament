import 'package:friends_tournament/src/data/database/dao/player_session_dao.dart';

/// The player of a specific sessions
/// Correspond to a row of the 'player_session' db table. [PlayerSessionDao]
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
