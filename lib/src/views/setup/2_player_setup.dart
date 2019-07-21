import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';
import 'package:friends_tournament/src/ui/slide_left_route.dart';
import 'package:friends_tournament/src/ui/text_field_tile.dart';
import 'package:friends_tournament/src/views/setup/3_match_setup.dart';

class PlayerSetup extends StatefulWidget {
  @override
  _PlayerSetupState createState() => _PlayerSetupState();
}

class _PlayerSetupState extends State<PlayerSetup> {
  List<TextFieldWrapper> _textFieldsList = new List<TextFieldWrapper>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SetupBloc _setupBloc;
  Map<int, String> _savedValues = new HashMap();

  @override
  Widget build(BuildContext context) {
    _setupBloc = SetupBlocProvider.of(context);

    return StreamBuilder(
      initialData: 0,
      builder: (context, snapshot) {
        return createBody(snapshot.data);
      },
      stream: _setupBloc.getPlayersNumber,
    );
  }

  Widget createBody(int playersNumber) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  child: StreamBuilder(
                      initialData: Map<int, String>(),
                      stream: _setupBloc.getPlayersName,
                      builder: (context, snapshot) {
                        return renderTextFields(playersNumber, snapshot.data);
                      })),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: createBottomBar(),
            )
          ],
        ),
      ),
    );
  }

  Widget renderTextFields(int playersNumber, Map<int, String> playersName) {
    if (_textFieldsList.length != playersNumber) {
      for (int i = 0; i < playersNumber; i++) {
        TextFieldWrapper textFieldWrapper =
            new TextFieldWrapper(TextEditingController(), "Player ${i + 1}");
        if (playersName.containsKey(i)) {
          textFieldWrapper.value = playersName[i];
          textFieldWrapper.textEditingController.text = playersName[i];
        }
        _textFieldsList.add(textFieldWrapper);
      }
    }
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            "Players",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return TextFieldTile(textFieldWrapper: _textFieldsList[index]);
              },
              itemCount: _textFieldsList.length),
        ),
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
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () {
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
    _setupBloc.setPlayersName.add(_savedValues);
  }

  void goToNextPage() {
    saveValues();
    if (_savedValues.length != _textFieldsList.length) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Complete all the fields')));
      return;
    }
    Navigator.push(context, SlideLeftRoute(page: MatchSetup()));
  }
}
