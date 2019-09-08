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

const getFinalScoreQuery =
    "SELECT id_player, sum(score) as final_score, players.name "
    "FROM player_session "
    "INNER JOIN players ON player_session.id_player = players.id "
    "GROUP BY id_player "
    "ORDER BY final_score DESC;";
