import 'package:friends_tournament/src/data/database/dao/tournament_dao.dart';

/// A tournament is played by [playersNumber] different player and the can be
/// a fixed number of players that plays at the same time [playersAstNumber].
/// A tournament is composed by different number of matches [matchesNumber].
/// Due to the 'player at the same time constraint', a match is divided in sessions.
/// Correspond to a row of the 'tournaments' db table [TournamentDao]
class Tournament {
  String id;
  String name;
  int playersNumber;
  int playersAstNumber;
  int matchesNumber;
  // 0 inactive, 1 active
  int isActive;

  Tournament(this.id, this.name, this.playersNumber, this.playersAstNumber,
      this.matchesNumber, this.isActive);

  @override
  String toString() {
    return 'Tournament{id: $id, name: $name, playersNumber: $playersNumber,'
        ' playersAstNumber: $playersAstNumber, matchesNumber: $matchesNumber, '
        'isActive: $isActive}';
  }
}
