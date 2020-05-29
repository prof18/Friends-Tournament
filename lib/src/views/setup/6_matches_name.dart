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

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';
import 'package:friends_tournament/src/ui/dialog_loader.dart';
import 'package:friends_tournament/src/ui/text_field_tile.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';
import 'package:friends_tournament/style/app_style.dart';

class MatchesName extends StatefulWidget {
  @override
  _MatchesNameState createState() => _MatchesNameState();
}

class _MatchesNameState extends State<MatchesName>
    with SingleTickerProviderStateMixin {
  List<TextFieldWrapper> _textFieldsList = new List<TextFieldWrapper>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SetupBloc _setupBloc;
  Map<int, String> _savedValues = new HashMap();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _setupBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setupBloc = SetupBlocProvider.of(context);

    return StreamBuilder(
      initialData: 0,
      stream: _setupBloc.getMatchesNumber,
      builder: (context, snapshot) {
        return createBody(snapshot.data);
      },
    );
  }

  Widget createBody(int matchesNumber) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: StreamBuilder(
                  initialData: new Map<int, String>(),
                  stream: _setupBloc.getMatchesName,
                  builder: (context, snapshot) {
                    return renderTextFields(matchesNumber, snapshot.data);
                  },
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget renderTextFields(int matchesNumber, Map<int, String> matchesName) {
    if (_textFieldsList.length != matchesNumber) {
      for (int i = 0; i < matchesNumber; i++) {
        TextFieldWrapper textFieldWrapper =
            TextFieldWrapper(TextEditingController(), "Match ${i + 1}");
        if (matchesName.containsKey(i)) {
          textFieldWrapper.value = matchesName[i];
          textFieldWrapper.textEditingController.text = matchesName[i];
        }
        _textFieldsList.add(textFieldWrapper);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(top: MarginsRaw.regular),
            child: SvgPicture.asset(
              'assets/matches-art.svg',
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
            "Matches",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: MarginsRaw.regular,
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
        Expanded(
          flex: 7,
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return TextFieldTile(textFieldWrapper: _textFieldsList[index]);
            },
            itemCount: _textFieldsList.length,
          ),
        )
      ],
    );
  }

  Widget createBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "btn1",
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            saveValues();
            Navigator.pop(context);
          },
        ),
        FloatingActionButton(
          heroTag: "btn2",
          child: Icon(Icons.done),
          onPressed: () {
            saveValues();
            goToNextPage();
          },
        )
      ],
    );
  }

  void saveValues() {
    for (int i = 0; i < _textFieldsList.length; i++) {
      TextFieldWrapper textField = _textFieldsList[i];
      if (textField.textEditingController.text.isNotEmpty) {
        textField.value = textField.textEditingController.text;
        _savedValues[i] = textField.textEditingController.text;
      } else {
        if (_savedValues.containsKey(i)) {
          _savedValues.remove(i);
        }
      }
    }
    _setupBloc.setMatchesName.add(_savedValues);
  }

  void goToNextPage() {
    if (_savedValues.length != _textFieldsList.length) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Complete all the fields')));
      return;
    }
    _showAlertDialog();
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          // TODO: localize
          title: Text('Tournament building'),
          content: const Text(
              "This will start the generation of the tournament. "
              "Please be sure that all the data are correct since you can't "
              "modify it later"),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('Proceed'),
              onPressed: () {
                Navigator.of(context).pop();
                _showLoaderAndStartProcess();
              },
            )
          ],
        );
      },
    );
  }

  _showLoaderAndStartProcess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogLoader(
        controller: _controller,
        // TODO: localize
        text: "Generating the tournament",
      ),
    );

    _setupBloc.setupTournament().then(
      (_) {
        print("I'm over on saving data on the db");
        _controller.reverse().then(
          (_) {
            Navigator.pop(context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TournamentBlocProvider(
                    child: TournamentScreen(),
                  ),
                ),
                (Route<dynamic> route) => false);
          },
        );
      },
    );
  }
}
