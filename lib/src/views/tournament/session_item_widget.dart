import 'package:flutter/material.dart';
import 'package:friends_tournament/src/ui/page_transformer.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/tournament/session_player_tile.dart';

class SessionItemWidget extends StatelessWidget {
  SessionItemWidget({
    @required this.item,
    @required this.pageVisibility,
  });

  // TODO: replace with correct item
  final String item;
  final PageVisibility pageVisibility;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 22.0,
        horizontal: 8.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          color: hexToColor("#C4C4C4"),
          child: Container(
            child: Center(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "Session 1",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: SessionPlayerTile(
                      playerName: "Player name",
                      score: 0,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16.0, right: 16, top: 8.0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        // TODO
                      },
                      // TODO: change the icon to edit when click done
                      child: Icon(Icons.done),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
