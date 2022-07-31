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
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';
import 'package:friends_tournament/src/ui/text_field_tile.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/src/style/app_style.dart';

class MatchesName extends StatelessWidget implements SetupPage {
  final List<TextFieldWrapper> _textFieldsList = new List<TextFieldWrapper>();
  final Map<int, String> _savedValues = new HashMap();
  final SetupBloc _setupBloc;

  MatchesName(this._setupBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: 0,
      stream: _setupBloc.getMatchesNumber,
      builder: (context, snapshot) {
        return createBody(snapshot.data);
      },
    );
  }

  Widget createBody(int matchesNumber) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: StreamBuilder(
              initialData: new Map<int, String>(),
              stream: _setupBloc.getMatchesName,
              builder: (context, snapshot) {
                return renderTextFields(matchesNumber, snapshot.data, context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget renderTextFields(
      int matchesNumber, Map<int, String> matchesName, BuildContext context) {
    if (_textFieldsList.length != matchesNumber) {
      _textFieldsList.clear();
      for (int i = 0; i < matchesNumber; i++) {
        TextFieldWrapper textFieldWrapper = TextFieldWrapper(
            TextEditingController(),
            "${AppLocalizations.of(context).translate('match_label')} ${i + 1}");
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
            padding: Margins.regular,
            child: SvgPicture.asset(
              'assets/matches-art.svg',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: MarginsRaw.regular,
              bottom: MarginsRaw.small,
              left: MarginsRaw.regular,
              right: MarginsRaw.regular),
          child: Text(
            AppLocalizations.of(context).translate('matches_name_title'),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: MarginsRaw.regular,
              left: MarginsRaw.regular,
              right: MarginsRaw.regular),
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
            padding: const EdgeInsets.only(
              top: MarginsRaw.regular,
              bottom: MarginsRaw.regular,
              left: MarginsRaw.small,
              right: MarginsRaw.small,
            ),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return TextFieldTile(
                    key: getKeyForMatchNameTextField(index),
                    textFieldWrapper: _textFieldsList[index]);
              },
              itemCount: _textFieldsList.length,
            ),
          ),
        )
      ],
    );
  }

  /// Return true if the list is valid, i.e. every match has a name
  bool isMatchNamesValid() {
    for (int i = 0; i < _textFieldsList.length; i++) {
      TextFieldWrapper textField = _textFieldsList[i];
      if (textField.textEditingController.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
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

  /// Return true if there are some duplicates
  bool areNamesDuplicate() {
    List<String> finalNameList = [];
    _textFieldsList.forEach((textFieldWrapper) {
      finalNameList.add(textFieldWrapper.textEditingController.text.trim());
    });

    var distinctNames = finalNameList.toSet().toList();
    return distinctNames.length != finalNameList.length;
  }

  @override
  bool onBackPressed() {
    saveValues();
    return true;
  }

  @override
  bool onNextPressed(BuildContext context) {
    if (areNamesDuplicate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('match_name_duplicated'),
          ),
        ),
      );
      return false;
    }

    saveValues();

    if (_savedValues.length == _textFieldsList.length && isMatchNamesValid()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)
                .translate('matches_name_empty_fields_message'),
          ),
        ),
      );
      return false;
    }
  }
}
