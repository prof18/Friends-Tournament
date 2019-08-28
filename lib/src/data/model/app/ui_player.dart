import 'package:friends_tournament/src/data/model/db/player.dart';

/// This objects is used to hold all the info about a player that is needed in
/// the UI, for example the score.
/// It is an extensions of the [Player] saved in the db.
class UIPlayer extends Player {
  int score;

  UIPlayer({id, name, this.score}) : super(id, name);
}
