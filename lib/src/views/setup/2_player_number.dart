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
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/style/app_style.dart';

class PlayersNumber extends StatelessWidget implements SetupPage {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: SafeArea(
        child: Container(
          decoration: getWidgetBorder(),
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
                          'assets/players_art.svg',
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
                        "Number of players",
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
                      elevation: 16,
                      borderRadius: BorderRadius.all(
                          Radius.circular(MarginsRaw.borderRadius)),
                      child: TextField(
//                      controller: _playersController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
//                      focusNode: _playersFocusNode,
//                      onSubmitted: (value) {
//                        changeTextFieldFocus(context, _playersFocusNode,
//                            _playersAstFocusNode);
//                      },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(16.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(16.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(16.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.grey[800]),
                            // TODO: localize
                            hintText: 'Number of players',
                            fillColor: Colors.white70),
//                              decoration: InputDecoration(
//                                filled: true,
//                                fillColor: Colors.white,
//                                border: InputBorder.none,
//                                labelText: 'Number of players',
//                              ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(),
                    )
                  ],
                ),
              )),
//            createBottomBar()
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool onBackPressed() {
    // TODO: implement onBackPressed
    throw UnimplementedError();
  }

  @override
  bool onNextPressed() {
    // TODO: implement onNextPressed
    throw UnimplementedError();
  }


}
