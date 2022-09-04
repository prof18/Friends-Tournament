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

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/data/model/db/player_session.dart';
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:provider/provider.dart';

class SessionPlayerTile extends StatelessWidget {
  final UIPlayer player;
  final int step;
  final UISession session;

  final double buttonSize = 20;
  final double iconSize = 16;

  const SessionPlayerTile({
    Key? key,
    required this.player,
    required this.session,
    this.step = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: Material(
        elevation: MarginsRaw.elevation,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlayerName(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPlayerScore(context),
                Padding(
                  padding: const EdgeInsets.only(right: MarginsRaw.small),
                  child: Row(
                    children: [
                      _buildDecrementScoreButton(context),
                      _buildIncrementScoreButton(context)
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerName() {
    return Padding(
      padding: const EdgeInsets.only(
        top: MarginsRaw.regular,
        left: MarginsRaw.regular,
      ),
      child: Text(
        player.name,
        style: AppTextStyle.textStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildPlayerScore(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MarginsRaw.small),
      child: Padding(
        padding: Margins.regular,
        child: Column(
          children: [
            Text(
              player.score.toString(),
              style: AppTextStyle.textStyle(fontSize: 32),
            ),
            Text(
              AppLocalizations.translate(context, 'score'),
              style: AppTextStyle.textStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDecrementScoreButton(BuildContext context) {
    return Visibility(
      visible: player.score == 0 ? false : true,
      child: Padding(
        padding: const EdgeInsets.only(right: MarginsRaw.small),
        child: GestureDetector(
          key: getKeyForScoreDecrease(player.name),
          onTap: () {
            int score = player.score;
            if (score - step >= 0) {
              Provider.of<TournamentProvider>(
                context,
                listen: false,
              ).setPlayerScore(
                PlayerSession(
                  player.id,
                  session.id,
                  player.score - step,
                ),
              );
            }
          },
          child: const Icon(
            Icons.remove,
            size: 36,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }

  Padding _buildIncrementScoreButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MarginsRaw.small),
      child: GestureDetector(
        key: getKeyForScoreIncrease(player.name),
        onTap: () {
          Provider.of<TournamentProvider>(
            context,
            listen: false,
          ).setPlayerScore(
            PlayerSession(
              player.id,
              session.id,
              player.score + step,
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 36,
          color: Colors.black,
        ),
      ),
    );
  }
}
