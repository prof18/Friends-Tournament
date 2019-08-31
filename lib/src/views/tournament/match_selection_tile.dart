import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/ui/utils.dart';

class MatchSelectionTile extends StatefulWidget {
  final UIMatch match;
  final AnimationController controller;

  MatchSelectionTile({this.match, this.controller});

  @override
  _MatchSelectionTileState createState() => _MatchSelectionTileState();
}

class _MatchSelectionTileState extends State<MatchSelectionTile> {
  TournamentBloc _tournamentBloc;

  @override
  Widget build(BuildContext context) {
    _tournamentBloc = TournamentBlocProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _tournamentBloc.setCurrentMatch.add(widget.match);
              widget.controller.fling(velocity: 1.0);
            },
            child: Container(
              decoration: widget.match.isSelected
                  ? BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    )))
                  : BoxDecoration(),
              child: Padding(
                padding: widget.match.isSelected
                    ? const EdgeInsets.only(
                        bottom: 8.0, left: 10.0, right: 10.0)
                    : const EdgeInsets.all(0.0),
                child: Text(
                  widget.match.name,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
