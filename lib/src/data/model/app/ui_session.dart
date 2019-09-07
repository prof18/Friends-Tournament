import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/db/session.dart';

/// This objects is used to hold all the info about a session that are needed in
/// the UI, for example all the players of the sessions.
/// It is an extensions of the [Session] saved in the db.
class UISession extends Session {
  List<UIPlayer> sessionPlayers;

  UISession({this.sessionPlayers, id, name, order})
      : super(id, name, order);
}
