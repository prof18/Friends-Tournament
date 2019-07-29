import 'package:friends_tournament/src/data/database/dao.dart';
import 'package:friends_tournament/src/data/model/tournament_match.dart';

class TournamentMatchDao implements Dao<TournamentMatch> {
  final columnTournamentId = "id_tournament";
  final columnMatchId = "id_match";

  @override
  String get tableName => "tournament_match";

  @override
  // TODO: implement createTableQuery
  String get createTableQuery => "CREATE TABLE $tableName ("
      "$columnTournamentId VARCHAR(255), "
      "$columnMatchId VARCHAR(255), "
      "PRIMARY KEY ($columnTournamentId, $columnMatchId)"
      ")";

  @override
  List<TournamentMatch> fromList(List<Map<String, dynamic>> query) {
    var tournamentMatchList = List<TournamentMatch>();
    for (Map map in query) {
      tournamentMatchList.add(fromMap(map));
    }
    return tournamentMatchList;
  }

  @override
  TournamentMatch fromMap(Map<String, dynamic> query) {
    var tournamentId = query[columnTournamentId];
    var matchId = query[tournamentId];
    return TournamentMatch(tournamentId, matchId);
  }

  @override
  Map<String, dynamic> toMap(TournamentMatch object) {
    return <String, dynamic>{
      columnTournamentId: object.tournamentId,
      columnMatchId: object.matchId
    };
  }
}
