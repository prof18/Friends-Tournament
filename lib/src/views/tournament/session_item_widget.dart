import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/views/tournament/session_player_tile.dart';

class SessionItemWidget extends StatelessWidget {
  SessionItemWidget({
    @required this.session,
  });

  final UISession session;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 8.0,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  session.name,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NotificationListener<ScrollEndNotification>(
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      UIPlayer player = session.sessionPlayers[index];
                      return SessionPlayerTile(
                        player: player,
                        session: session,
                      );
                    },
                    itemCount: session.sessionPlayers.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
