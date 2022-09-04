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

/// Generate a tournament id from the hash code of "${DateTime.now()}-$idName"
String generateTournamentId(String tournamentName) {
  var idName = _generateGenericId(tournamentName);
  return "${DateTime.now()}-$idName".hashCode.toString();
}

/// Generate a match id from the hash code of "$tournamentId-$idName"
String generateMatchId(String? tournamentId, String matchName) {
  var idName = _generateGenericId(matchName);
  return "$tournamentId-$idName".hashCode.toString();
}

/// Generate a Session id from the hashCode of "$matchId-$idName"
String generateSessionId(String? matchId, String sessionName) {
  var idName = _generateGenericId(sessionName);
  return "$matchId-$idName".hashCode.toString();
}

/// Generate a Player Id starting from the name
String generatePlayerId(String playerName) {
  return _generateGenericId(playerName);
}

/// Generate a generic id using hash code
String _generateGenericId(String name){
  return name
      .toLowerCase()
      .trim()
      .replaceAll(" ", "")
      .hashCode
      .toString();
}