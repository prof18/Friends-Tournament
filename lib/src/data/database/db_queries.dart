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

/// Get all the matches for the current tournament
const allMatchesForActiveTournamentQuery =
    "SELECT tournament_match.id_match, matches.name, matches.is_active, matches.match_order "
    "FROM tournament_match "
    "INNER JOIN matches ON tournament_match.id_match = matches.id "
    "WHERE tournament_match.id_tournament = '<>' "
    "ORDER BY matches.match_order ASC;";

const getMatchSessionsQuery =
    "SELECT matches_session.id_session, sessions.name, sessions.session_order "
    "FROM matches_session "
    "INNER JOIN sessions ON matches_session.id_session = sessions.id "
    "WHERE matches_session.id_match = '<>' "
    "ORDER BY sessions.session_order ASC;";

const getSessionPlayersQuery =
    "SELECT player_session.id_player as player_id, players.name as player_name, player_session.score as player_score "
    "FROM sessions "
    "INNER JOIN player_session ON sessions.id = player_session.id_session "
    "INNER JOIN players ON player_id = players.id "
    "WHERE sessions.id = '<>' "
    "ORDER BY player_name;";

const getTournamentScoreQuery =
    "SELECT id_tournament, player_session.id_player, sum(score) as final_score, players.name "
    "FROM tournaments "
    "INNER JOIN tournament_player ON tournaments.id = tournament_player.id_tournament "
    "INNER JOIN player_session ON tournament_player.id_player = player_session.id_player "
    "INNER JOIN players ON player_session.id_player = players.id "
    "WHERE tournaments.id = '<>' "
    "GROUP BY player_session.id_player "
    "ORDER BY final_score DESC";
