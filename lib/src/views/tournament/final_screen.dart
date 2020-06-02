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
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/style/app_style.dart';


class FinalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TournamentBloc tournamentBloc = TournamentBlocProvider.of(context);

    // TODO: maybe make a screen with only the winner, on the bottom some
    //    buttons to go to the full leaderboard or the create another tournament

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Padding(
            padding: Margins.regular,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 36, left: MarginsRaw.regular),
                        child: StreamBuilder<Tournament>(
                            stream: tournamentBloc.activeTournament,
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.hasData ? snapshot.data.name : "",
                                style: TextStyle(fontSize: 28),
                              );
                            }),
                      ),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: Margins.regular,
                          child: Align(
                            alignment: FractionalOffset.center,
                            child: SvgPicture.asset(
                              'assets/winner-art.svg',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: MarginsRaw.regular,
                          left: MarginsRaw.regular,
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
                      Align(
                        alignment: FractionalOffset.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: MarginsRaw.regular,
                            right: MarginsRaw.regular,
                            bottom: MarginsRaw.regular
                          ),
                          child: Text(
                            "The winner is.. ",
                            style: TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<List<UIPlayer>>(
                            stream: tournamentBloc.leaderboardPlayers,
                            builder: (context, snapshot) {
                              return Align(
                                alignment: FractionalOffset.topLeft,
                                child: Padding(
                                  padding: Margins.regular,
                                  child: Text(
                                    snapshot.hasData
                                        ? "${snapshot.data.first.name} 🎉"
                                        : "Nobody 😧",
                                    style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: MarginsRaw.regular,
                              bottom: MarginsRaw.regular),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: MarginsRaw.regular),
                                  child: RaisedButton(
                                    onPressed: () {},
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MarginsRaw.borderRadius),
                                      side: BorderSide(color: AppColors.blue),
                                    ),
                                    color: AppColors.blue,
                                    textColor: Colors.white,
                                    padding: Margins.regular,
                                    child: Text(
                                      "Leaderboard",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RaisedButton(
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        MarginsRaw.borderRadius),
                                    side: BorderSide(color: AppColors.blue),
                                  ),
                                  color: AppColors.blue,
                                  textColor: Colors.white,
                                  padding: Margins.regular,
                                  child: Text(
                                    "New tournament",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _renderEmptyLeaderboard() {
    return Center(
      child: Text(
          // TODO: localize
          "Ops, somethings goes wrong! 🤷‍♂️‍"),
    );
  }
}

/*
Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.only(top: MarginsRaw.regular),
                        child: SizedBox(
                          width: 60,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(top: MarginsRaw.regular),
                        child: Text(
                          'Leaderboard',
                          style: TextStyle(fontSize: 28),
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

 */
