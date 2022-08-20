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
import 'package:friends_tournament/src/ui/setup_counter_widget.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:provider/provider.dart';

class PlayersAST extends StatelessWidget implements SetupPage {
  const PlayersAST({Key? key}) : super(key: key);

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
                    'assets/player-ast-art.svg',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: MarginsRaw.regular,
                  bottom: MarginsRaw.small,
                ),
                child: Text(
                  AppLocalizations.translate(context, 'number_of_players_ast_title',),
                  style: AppTextStyle.onboardingTitleStyle,
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
              Consumer<SetupProvider>(
                builder: (context, provider, child) {
                  return SetupCounterWidget(
                    minValue: 2,
                    currentValue: provider.playersAstNumber,
                    onIncrease: (newValue) {
                      provider.setPlayersAstNumber(newValue);
                    },
                    onDecrease: (newValue) {
                      provider.setPlayersAstNumber(newValue);
                    },
                    maxValue: provider.playersNumber,
                  );
                },
              ),
              Expanded(
                flex: 4,
                child: Container(),
              )
            ],
          ),
        )),
      ],
    );
  }

  @override
  bool onBackPressed(BuildContext context) {
    return true;
  }

  @override
  bool onNextPressed(BuildContext context) {
    final provider = Provider.of<SetupProvider>(context, listen: false);
    if (provider.playersNumber - provider.playersAstNumber == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.translate(context, 'match_with_one_player',),
          ),
        ),
      );
      return false;
    }

    return true;
  }
}
