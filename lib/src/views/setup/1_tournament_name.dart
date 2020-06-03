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
import 'package:friends_tournament/src/ui/text_field_decoration.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/src/style/app_style.dart';

class TournamentName extends StatelessWidget implements SetupPage {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _tournamentController =
      new TextEditingController();
  final SetupBloc setupBloc;

  TournamentName(this.setupBloc);

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
                        'assets/intro-art.svg',
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
                      "Tournament Name",
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
                  Material(
                    elevation: MarginsRaw.elevation,
                    borderRadius: BorderRadius.all(
                      Radius.circular(MarginsRaw.borderRadius),
                    ),
                    child: TextField(
                      controller: _tournamentController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      // TODO: localize
                      decoration: getTextFieldDecoration('Tournament Name'),
                    ),
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
    // Nothing to do here!
    return true;
  }

  @override
  bool onNextPressed() {
    if (_tournamentController.text.isEmpty) {
      // TODO: localize
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Complete all the fields')));
      return false;
    }

    setupBloc.setTournamentName.add(_tournamentController.text);
    return true;
  }
}
