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
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/provider/setup_provider.dart';
import 'package:friends_tournament/src/ui/setup_counter_widget.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:provider/provider.dart';

class MatchesNumber extends StatelessWidget implements SetupPage {

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
                    AppLocalizations.of(context)
                        .translate('number_of_matches_title'),
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
                Consumer<SetupProvider>(
                  builder: (context, provider, child) {
                    return SetupCounterWidget(
                      minValue: 1,
                      currentValue: provider.matchesNumber,
                      onIncrease: (newValue) {
                        provider.setMatchesNumber(newValue);
                      },
                      onDecrease: (newValue) {
                        provider.setMatchesNumber(newValue);
                      },
                    );
                  },
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
    return true;
  }

  @override
  bool onNextPressed(BuildContext context) {
    return true;
  }
}
