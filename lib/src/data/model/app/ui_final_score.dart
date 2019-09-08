import 'package:friends_tournament/src/data/model/db/player.dart';

class UIFinalScore extends Player {
  int score;

  UIFinalScore({this.score, id, name}) : super(id, name);
}
