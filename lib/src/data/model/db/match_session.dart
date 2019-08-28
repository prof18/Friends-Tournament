import 'package:friends_tournament/src/data/database/dao/match_session_dao.dart';

/// The session of a specific match
/// Correspond to a row of the 'matches_session' db table. [MatchSessionDao]
class MatchSession {
  String matchId;
  String sessionId;

  MatchSession(this.matchId, this.sessionId);

  @override
  String toString() {
    return 'MatchSession{matchId: $matchId, sessionId: $sessionId}';
  }
}
