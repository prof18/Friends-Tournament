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
import 'package:friends_tournament/src/utils/is_tablet.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:provider/provider.dart';

class PlayersNumber extends StatelessWidget implements SetupPage {
  const PlayersNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(
              isTablet(context) ? MarginsRaw.large : MarginsRaw.regular,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: _buildImage(),
                ),
                _buildTitle(context),
                _buildChipSeparator(),
                _buildPlayerNumberCounter(),
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

  Widget _buildImage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: MarginsRaw.regular),
        child: SvgPicture.asset('assets/players_art.svg'),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isTablet(context) ? MarginsRaw.large : MarginsRaw.regular,
        bottom: MarginsRaw.small,
      ),
      child: Text(
        AppLocalizations.translate(context, 'number_of_players_title'),
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

  Widget _buildPlayerNumberCounter() {
    return Consumer<SetupProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding:  EdgeInsets.only(
            top: isTablet(context) ? MarginsRaw.regular : 0.0,
          ),
          child: SetupCounterWidget(
            minValue: 2,
            currentValue: provider.playersNumber,
            onIncrease: (newValue) {
              provider.setPlayersNumber(newValue);
            },
            onDecrease: (newValue) {
              provider.setPlayersNumber(newValue);
            },
          ),
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
    final provider = Provider.of<SetupProvider>(context, listen: false);
    if (provider.playersNumber != 0) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.translate(
              context,
              'player_name_empty_fields',
            ),
          ),
        ),
      );
      return false;
    }
  }
}
