/*
 * Copyright 2020 Marco Gomiero
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
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/ui/setup_counter_widget.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/style/app_style.dart';

class PlayersAST extends StatelessWidget implements SetupPage {
  final SetupBloc _setupBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PlayersAST(this._setupBloc);

  // TODO: add some check. For example If there is 5 player and 2 ast player, its not possible

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white12,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Padding(
              padding: Margins.regular,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.only(top: MarginsRaw.regular),
                      child: SvgPicture.asset(
                        'assets/player-ast-art.svg',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: MarginsRaw.regular,
                      bottom: MarginsRaw.small,
                    ),
                    child: Text(
                      // TODO: localize
                      "Number of players at the same time",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: MarginsRaw.medium,
                      bottom: MarginsRaw.medium,
                    ),
                    child: Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(
                          MarginsRaw.borderRadius,
                        ),
                      ),
                      height: 6,
                      width: 60,
                    ),
                  ),
                  SetupCounterWidget(
                    inputStream: _setupBloc.setPlayersAstNumber,
                    outputStream: _setupBloc.getPlayersAstNumber,
                    minValue: 2,
                    maxValue: _setupBloc.getCurrentPlayersNumber(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  bool onBackPressed() {
    return true;
  }

  @override
  bool onNextPressed() {
    return true;
  }
}
