import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';
import 'package:friends_tournament/src/ui/dialog_loader.dart';
import 'package:friends_tournament/src/ui/text_field_tile.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';

class MatchSetup extends StatefulWidget {
  @override
  _MatchSetupState createState() => _MatchSetupState();
}

class _MatchSetupState extends State<MatchSetup>
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: createBottomBar(),
            )
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
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            "Matches",
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
        text: "This is loading something",
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
