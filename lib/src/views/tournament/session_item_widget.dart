import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/ui/page_transformer.dart';
import 'package:friends_tournament/src/views/tournament/session_player_tile.dart';

class SessionItemWidget extends StatelessWidget {
  SessionItemWidget({
    @required this.session,
    @required this.pageVisibility,
  });

  final UISession session;
  final PageVisibility pageVisibility;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 22.0,
        horizontal: 8.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 8.0,
        child: Container(
          child: Container(
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      UIPlayer player = session.sessionPlayers[index];
                      return SessionPlayerTile(
                        playerName: player.name,
                        score: player.score,
                      );
                    },
                    itemCount: session.sessionPlayers.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
