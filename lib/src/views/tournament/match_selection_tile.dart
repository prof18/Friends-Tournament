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
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:provider/provider.dart';

class MatchSelectionTile extends StatelessWidget {
  final UIMatch match;
  final AnimationController controller;

  MatchSelectionTile({Key key, this.match, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: getKeyForMatchChange(match.name),
            onTap: () {
              Provider.of<TournamentProvider>(
                context,
                listen: false,
              ).setCurrentMatch(match);
              controller.fling(velocity: 1.0);
            },
            child: Container(
              decoration: match.isSelected
                  ? BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    )))
                  : BoxDecoration(),
              child: Padding(
                padding: match.isSelected
                    ? const EdgeInsets.only(
                        bottom: 8.0, left: 10.0, right: 10.0)
                    : const EdgeInsets.all(0.0),
                child: Text(
                  match.name,
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
