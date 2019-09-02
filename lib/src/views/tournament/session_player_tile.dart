import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/player_session.dart';

class SessionPlayerTile extends StatefulWidget {
  final UIPlayer player;
  final int step;
  final UISession session;

  final double buttonSize = 20;
  final double iconSize = 16;

  SessionPlayerTile({this.player, this.session, this.step = 1});

  @override
  _SessionPlayerTileState createState() => _SessionPlayerTileState();
}

class _SessionPlayerTileState extends State<SessionPlayerTile> {
  TournamentBloc tournamentBloc;

  @override
  Widget build(BuildContext context) {
    tournamentBloc = TournamentBlocProvider.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.player.name,
            style: TextStyle(fontSize: 22),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: widget.buttonSize,
                height: widget.buttonSize,
                child: FloatingActionButton(
                  onPressed: _decrementScore,
                  elevation: 2,
                  child: Icon(
                    Icons.remove,
                    size: widget.iconSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.player.score.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                width: widget.buttonSize,
                height: widget.buttonSize,
                child: FloatingActionButton(
                  onPressed: _incrementScore,
                  elevation: 2,
                  child: Icon(
                    Icons.add,
                    size: widget.iconSize,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _incrementScore() {
    tournamentBloc.setPlayerScore.add(
      PlayerSession(widget.player.id, widget.session.id,
          widget.player.score + widget.step),
    );
  }

  _decrementScore() {
    int score = widget.player.score;
    if (score - widget.step >= 0) {
      tournamentBloc.setPlayerScore.add(
        PlayerSession(widget.player.id, widget.session.id,
            widget.player.score - widget.step),
      );
    }
  }
}
