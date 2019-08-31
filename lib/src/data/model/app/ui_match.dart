import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/match.dart' as tournament;

/// This objects is used to hold all the info about a match that are needed in
/// the UI, for example all the session of the match.
/// It is an extensions of the [] saved in the db.
class UIMatch extends tournament.Match {
  List<UISession> matchSessions;
  bool isSelected = false;

  UIMatch({this.matchSessions, id, name, isActive}) : super(id, name, isActive);
}
