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
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/provider/setup_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/text_field_decoration.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:provider/provider.dart';

class TournamentName extends StatelessWidget implements SetupPage {
  final TextEditingController _tournamentController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    AppLocalizations.of(context)
                        .translate('tournament_name_title'),
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
                    decoration: getTextFieldDecoration(
                      AppLocalizations.of(context)
                          .translate('tournament_name_title'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool onBackPressed(BuildContext context) {
    // Nothing to do here!
    return true;
  }

  @override
  bool onNextPressed(BuildContext context) {
    if (_tournamentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)
                .translate('tournament_name_empty_fields_message'),
          ),
        ),
      );
      return false;
    }
    Provider.of<SetupProvider>(context, listen: false)
        .setTournamentName(_tournamentController.text);

    return true;
  }
}
