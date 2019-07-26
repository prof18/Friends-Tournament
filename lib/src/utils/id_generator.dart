String generateTournamentId(String tournamentName) {
  var idName = _generateGenericId(tournamentName);
  return "${DateTime.now()}-$idName".hashCode.toString();
}

String generateMatchId(String tournamentId, String matchName) {
  var idName = _generateGenericId(matchName);
  return "$tournamentId-$idName".hashCode.toString();
}

String generateSessionId(String matchId, String sessionName) {
  var idName = _generateGenericId(sessionName);
  return "$matchId-$idName".hashCode.toString();
}

String generatePlayerId(String playerName) {
  return _generateGenericId(playerName);
}

String _generateGenericId(String name){
  return name
      .toLowerCase()
      .trim()
      .replaceAll(" ", "")
      .hashCode
      .toString();
}