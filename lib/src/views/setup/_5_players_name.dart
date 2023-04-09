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
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';
import 'package:friends_tournament/src/provider/setup_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/text_field_tile.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/is_tablet.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/ui/chip_separator.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:provider/provider.dart';

class PlayersName extends StatelessWidget implements SetupPage {
  final List<TextFieldWrapper> _textFieldsList = <TextFieldWrapper>[];
  final Map<int, String> _savedValues = HashMap();

  PlayersName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.all(
            isTablet(context) ? MarginsRaw.large : MarginsRaw.regular,
          ),
          child: _createBody(
            provider.playersNumber,
            provider.playersName,
            context,
          ),
        );
      },
    );
  }

  Widget _createBody(
    int playersNumber,
    UnmodifiableMapView<int, String> players,
    BuildContext context,
  ) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: _renderContent(
              playersNumber,
              players,
              context,
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderContent(
    int playersNumber,
    Map<int, String> playersName,
    BuildContext context,
  ) {
    if (_textFieldsList.length != playersNumber) {
      _textFieldsList.clear();
      for (int i = 0; i < playersNumber; i++) {
        var action = TextInputAction.next;
        if (i == playersNumber - 1) {
          action = TextInputAction.done;
        }
        TextFieldWrapper textFieldWrapper = TextFieldWrapper(
          TextEditingController(),
          "${AppLocalizations.translate(
            context,
            'player_label',
          )} ${i + 1}",
          action,
        );
        if (playersName.containsKey(i)) {
          textFieldWrapper.value = playersName[i];
          textFieldWrapper.textEditingController.text = playersName[i]!;
        }
        _textFieldsList.add(textFieldWrapper);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: _buildImage(),
        ),
        _buildTitle(context),
        _buildChipSeparator(),
        Expanded(
          flex: 7,
          child: _buildTextFields(),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Center(
      child: SvgPicture.asset('assets/players_art.svg'),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isTablet(context) ? MarginsRaw.large : MarginsRaw.regular,
        bottom: MarginsRaw.small,
      ),
      child: Text(
        AppLocalizations.translate(context, 'players_name_title'),
        style: AppTextStyle.onboardingTitleStyle,
      ),
    );
  }

  Widget _buildChipSeparator() {
    return const Padding(
      padding: EdgeInsets.only(
        top: MarginsRaw.regular,
      ),
      child: ChipSeparator(),
    );
  }

  Widget _buildTextFields() {
    return Padding(
      padding: const EdgeInsets.only(
        top: MarginsRaw.regular,
        bottom: MarginsRaw.regular,
      ),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:  EdgeInsets.symmetric(
              vertical: isTablet(context) ? MarginsRaw.regular : MarginsRaw.small,
            ),
            child: TextFieldTile(
              key: getKeyForPlayerNameTextField(index),
              textFieldWrapper: _textFieldsList[index],
            ),
          );
        },
        itemCount: _textFieldsList.length,
      ),
    );
  }

  void saveValues(BuildContext context) {
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
    Provider.of<SetupProvider>(context, listen: false)
        .setPlayersName(_savedValues);
  }

  @override
  bool onBackPressed(BuildContext context) {
    saveValues(context);
    return true;
  }

  /// Return true if the list is valid, i.e. every player has a name
  bool isPlayerNamesValid() {
    for (int i = 0; i < _textFieldsList.length; i++) {
      TextFieldWrapper textField = _textFieldsList[i];
      if (textField.textEditingController.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  /// Return true if there are some duplicates
  bool areNamesDuplicate() {
    List<String> finalNameList = [];
    for (var textFieldWrapper in _textFieldsList) {
      finalNameList.add(textFieldWrapper.textEditingController.text.trim());
    }

    var distinctNames = finalNameList.toSet().toList();
    return distinctNames.length != finalNameList.length;
  }

  @override
  bool onNextPressed(BuildContext context) {
    if (areNamesDuplicate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.translate(context, 'player_name_duplicated'),
          ),
        ),
      );
      return false;
    }

    saveValues(context);

    if (_savedValues.length == _textFieldsList.length && isPlayerNamesValid()) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.translate(
              context,
              'player_name_empty_fields_message',
            ),
          ),
        ),
      );
      return false;
    }
  }
}
