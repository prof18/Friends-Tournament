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
import 'package:friends_tournament/src/ui/chip_separator.dart';
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
                child: _buildImage(),
              ),
              _buildTitle(context),
              _buildChipSeparator(),
              _buildPlayerASTCounter(),
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

  Widget _buildImage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: MarginsRaw.regular),
        child: SvgPicture.asset('assets/player-ast-art.svg'),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: MarginsRaw.regular,
        bottom: MarginsRaw.small,
      ),
      child: Text(
        AppLocalizations.translate(context, 'number_of_players_ast_title'),
        style: AppTextStyle.onboardingTitleStyle,
      ),
    );
  }

  Widget _buildChipSeparator() {
    return const Padding(
      padding: EdgeInsets.only(
        top: MarginsRaw.medium,
        bottom: MarginsRaw.medium,
      ),
      child: ChipSeparator(),
    );
  }

  Widget _buildPlayerASTCounter() {
    return Consumer<SetupProvider>(
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
    );
  }

  @override
  bool onBackPressed(BuildContext context) {
    return true;
  }

  @override
  bool onNextPressed(BuildContext context) {
    return true;
  }
}
