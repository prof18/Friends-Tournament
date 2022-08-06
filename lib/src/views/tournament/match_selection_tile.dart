/*
 * Copyright 2019 Marco Gomiero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';

class MatchSelectionTile extends StatefulWidget {
  final UIMatch match;
  final AnimationController controller;

  MatchSelectionTile({Key key, @required this.match, @required this.controller})
      : super(key: key);

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
            key: getKeyForMatchChange(widget.match.name),
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
