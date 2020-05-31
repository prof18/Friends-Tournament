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

/// Adapted from https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/shrine/shopping_cart.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/ui/expanding_bottom_sheet.dart';
import 'package:friends_tournament/src/ui/text_field_decoration.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/tournament/leaderboard_item_tile.dart';
import 'package:friends_tournament/style/app_style.dart';

const double _leftColumnWidth = 60.0;

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    TournamentBloc tournamentBloc = TournamentBlocProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: MarginsRaw.regular),
                        child: SizedBox(
                          width: _leftColumnWidth,
                          child: IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: () =>
                                ExpandingBottomSheet.of(context).close(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: MarginsRaw.regular),
                        child: Text(
                          'Leaderboard',
                          style: TextStyle(fontSize: 36),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: Margins.regular,
                      child: SvgPicture.asset(
                        'assets/podium-art.svg',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: MarginsRaw.regular,
                      left: MarginsRaw.regular,
                      bottom: MarginsRaw.regular,
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
                    flex: 6,
                    child: Padding(
                      padding: Margins.small,
                      child: StreamBuilder<List<UIPlayer>>(
                        initialData: [],
                        stream: tournamentBloc.leaderboardPlayers,
                        builder: (context, snapshot) {
                          return snapshot.data.isNotEmpty
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    UIPlayer uiPlayer = snapshot.data[index];
                                    return LeaderboardItemTile(
                                      uiPlayer: uiPlayer,
                                      position: index + 1,
                                    );
                                  },
                                )
                              : _renderEmptyLeaderboard();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderEmptyLeaderboard() {
    return Center(
      child: Text(
          // TODO: localize
          "Not matches started yet! 🤷‍♂️‍"),
    );
  }
}

/*



 */
