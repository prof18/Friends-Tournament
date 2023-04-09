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
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';

class LeaderboardItemTile extends StatelessWidget {
  final UIPlayer uiPlayer;
  final int position;

  const LeaderboardItemTile({
    Key? key,
    required this.uiPlayer,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: MarginsRaw.elevation,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          _buildPlayerPosition(),
          _buildPlayerName(),
          const Spacer(),
          _buildPlayerScore(),
        ],
      ),
    );
  }

  Widget _buildPlayerPosition() {
    return Padding(
      padding: const EdgeInsets.only(
        top: MarginsRaw.regular,
        bottom: MarginsRaw.regular,
        left: MarginsRaw.regular,
      ),
      child: Text(
        position.toString(),
        style: AppTextStyle.textStyle(fontSize: 16),
        key: getKeyForLeaderboardPlayerPosition(uiPlayer.name),
      ),
    );
  }

  Widget _buildPlayerName() {
    return Padding(
      padding: Margins.regular,
      child: Text(
        uiPlayer.name,
        style: AppTextStyle.textStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildPlayerScore() {
    return Padding(
      padding: Margins.regular,
      child: Text(
        uiPlayer.score.toString(),
        style: AppTextStyle.textStyle(fontSize: 24),
        key: getKeyForLeaderboardPlayerScore(uiPlayer.name),
      ),
    );
  }
}
