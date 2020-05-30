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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/ui/slide_left_route.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/setup/5_players_name.dart';
import 'package:friends_tournament/style/app_style.dart';

class NumberSetup extends StatefulWidget {
  @override
  _NumberSetupState createState() => _NumberSetupState();
}

class _NumberSetupState extends State<NumberSetup> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Text Fields Controllers
  final TextEditingController _tournamentController =
      new TextEditingController();
  final TextEditingController _playersController = new TextEditingController();
  final TextEditingController _playersAstController =
      new TextEditingController();
  final TextEditingController _matchesController = new TextEditingController();

  // Text Fields Focus
  FocusNode _tournamentFocusNode;
  FocusNode _playersFocusNode;
  FocusNode _playersAstFocusNode;
  FocusNode _matchesFocusNode;

  @override
  void initState() {
    super.initState();
    _tournamentFocusNode = FocusNode();
    _playersFocusNode = FocusNode();
    _playersAstFocusNode = FocusNode();
    _matchesFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _tournamentFocusNode.dispose();
    _playersFocusNode.dispose();
    _playersAstFocusNode.dispose();
    _matchesFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(child: renderBody()),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: renderBottomBar(),
                  )
                ],
              ),
            );
          }),
    );
  }

  void goToNextPage() {
    var setupBloc = SetupBlocProvider.of(context);

    if (_tournamentController.text.isEmpty ||
        _playersController.text.isEmpty ||
        _playersAstController.text.isEmpty ||
        _matchesController.text.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Complete all the fields')));
      return;
    }

    setupBloc.setTournamentName.add(_tournamentController.text);
    setupBloc.setPlayersNumber.add(int.parse(_playersController.text));
    setupBloc.setPlayersAstNumber.add(int.parse(_playersAstController.text));
    setupBloc.setMatchesNumber.add(int.parse(_matchesController.text));

//    Navigator.push(
//      context,
//      SlideLeftRoute(page: PlayersName()),
//    );
  }

  Widget renderBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "btn2",
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            goToNextPage();
          },
        )
      ],
    );
  }

  Widget renderBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
            child: Text(
              "New Tournament",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                        controller: _tournamentController,
                        textInputAction: TextInputAction.next,
                        focusNode: _tournamentFocusNode,
                        onSubmitted: (value) {
                          changeTextFieldFocus(
                              context, _tournamentFocusNode, _playersFocusNode);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tournament Name',
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SvgPicture.asset(
                          'assets/players_icon.svg',
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Material(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0)),
                            elevation: 16,
                            child: TextField(
                              controller: _playersController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              focusNode: _playersFocusNode,
                              onSubmitted: (value) {
                                changeTextFieldFocus(context, _playersFocusNode,
                                    _playersAstFocusNode);
                              },
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
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SvgPicture.asset(
                          'assets/players_ast_icon.svg',
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _playersAstController,
                            textInputAction: TextInputAction.next,
                            focusNode: _playersAstFocusNode,
                            onSubmitted: (value) {
                              changeTextFieldFocus(context,
                                  _playersAstFocusNode, _matchesFocusNode);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Number of players at the same time',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SvgPicture.asset(
                          'assets/matches_icon.svg',
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            focusNode: _matchesFocusNode,
                            onSubmitted: (value) {
                              _matchesFocusNode.unfocus();
                              goToNextPage();
                            },
                            controller: _matchesController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Number of matches',
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
