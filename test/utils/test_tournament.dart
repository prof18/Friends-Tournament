/*
 * Copyright 2020 Marco Gomiero
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

class TestTournament {
  static const int playersNumber = 4;
  static const int playersAstNumber = 2;
  static const int matchesNumber = 5;
  static const String tournamentName = "Test Tournament";
  static final Map<int, String> playersName = {
    0: "Player1",
    1: "Player2",
    2: "Player3",
    3: "Player4",
  };
  static final Map<int, String> matchesName = {
    0: "Match1",
    1: "Match2",
    2: "Match3",
    3: "Match4",
    4: "Match5",
  };

  // Matches
  static const onGoingMatchesInsertQuery = '''
    INSERT INTO matches (id, name, is_active, match_order) VALUES ('493865689', 'Match 1', '0', '0'), ('66702220', 'Match 3', '1', '2'), ('707642574', 'Match 2', '0', '1');
  ''';

  // MatchesSession
  static const onGoingMatchesSessionInsertQuery = '''
    INSERT INTO matches_session (id_match, id_session) VALUES ('493865689', '291049996'), ('493865689', '910141880'), ('66702220', '675643747'),('66702220', '791280778'),('707642574', '908148273'),('707642574', '910398819');
  ''';

  // PlayerSession
  static const onGoingPlayerSessionInsertQuery = '''
    INSERT INTO player_session (id_player, id_session, score) VALUES ('183402969', '291049996', '2'),('183402969', '675643747', '0'),('183402969', '908148273', '1'),('479405346', '291049996', '1'),('479405346', '791280778', '0'),('479405346', '908148273', '0'),('761153207', '675643747', '0'),('761153207', '910141880', '3'),('761153207', '910398819', '2'),('942660699', '791280778', '0'),('942660699', '910141880', '1'),('942660699', '910398819', '0');
  ''';

  // Players
  static const onGoingPlayerInsertQuery = '''
    INSERT INTO players (id, name) VALUES ('183402969', 'Player 3'),('479405346', 'Player 2'),('761153207', 'Player 1'),('942660699', 'Player 4');
  ''';

  // Sessions
  static const onGoingSessionInsertQuery = '''
    INSERT INTO sessions (id, name, session_order) VALUES ('291049996', 'Session 1', '0'),('675643747', 'Session 1', '0'),('791280778', 'Session 2', '1'),('908148273', 'Session 2', '1'),('910141880', 'Session 2', '1'),('910398819', 'Session 1', '0');
  ''';

  // TournamentMatch
  static const onGoingTournamentMatchInsertQuery = '''
    INSERT INTO tournament_match (id_tournament, id_match) VALUES ('945687886', '493865689'),('945687886', '66702220'),('945687886', '707642574');
  ''';

  // Tournament Player
  static const onGoingTournamentPlayerInsertQuery = '''
    INSERT INTO tournament_player (id_player, id_tournament, final_score) VALUES ('183402969', '945687886', '0'), ('479405346', '945687886', '0'),('761153207', '945687886', '0'),('942660699', '945687886', '0');
  ''';

  // Tournament
  static const onGoingTournamentInsertQuery = '''
    INSERT INTO tournaments (id, name, players_number, players_ast_number, matches_number, is_active) VALUES ('945687886', 'Tournament	', '4', '2', '3', '1');  
  ''';

}
