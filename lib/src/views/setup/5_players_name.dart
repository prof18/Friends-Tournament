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
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';
import 'package:friends_tournament/src/ui/text_field_tile.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/src/style/app_style.dart';

class PlayersName extends StatelessWidget implements SetupPage {
  final List<TextFieldWrapper> _textFieldsList = new List<TextFieldWrapper>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final SetupBloc _setupBloc;
  final Map<int, String> _savedValues = new HashMap();

  PlayersName(this._setupBloc);

  @override
  Widget build(BuildContext context) {
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
                    return renderTextFields(
                        playersNumber, snapshot.data, context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderTextFields(
      int playersNumber, Map<int, String> playersName, BuildContext context) {
    if (_textFieldsList.length != playersNumber) {
      _textFieldsList.clear();
      for (int i = 0; i < playersNumber; i++) {
        TextFieldWrapper textFieldWrapper = new TextFieldWrapper(
            TextEditingController(),
            "${AppLocalizations.of(context).translate('player_label')} ${i + 1}");
        if (playersName.containsKey(i)) {
          textFieldWrapper.value = playersName[i];
          textFieldWrapper.textEditingController.text = playersName[i];
        }
        _textFieldsList.add(textFieldWrapper);
      }
    }
    return Padding(
      padding: Margins.regular,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 3,
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
              AppLocalizations.of(context).translate('players_name_title'),
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
            child: Padding(
              padding: const EdgeInsets.only(top: MarginsRaw.regular),
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return TextFieldTile(
                        textFieldWrapper: _textFieldsList[index]);
                  },
                  itemCount: _textFieldsList.length),
            ),
          ),
        ],
      ),
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

  @override
  bool onBackPressed() {
    saveValues();
    return true;
  }

  @override
  bool onNextPressed(BuildContext context) {
    saveValues();
    if (_savedValues.length != _textFieldsList.length) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)
                .translate('player_name_empty_fields_message'),
          ),
        ),
      );
      return false;
    }
    return true;
  }
}
