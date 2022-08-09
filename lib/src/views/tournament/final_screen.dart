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
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/provider/leaderboard_provider.dart';
import 'package:friends_tournament/src/provider/setup_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/error_dialog.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/settings/settings_screen.dart';
import 'package:friends_tournament/src/views/setup/setup_pages_container.dart';
import 'package:friends_tournament/src/views/tournament/leaderboard_page.dart';
import 'package:provider/provider.dart';

class FinalScreen extends StatefulWidget {
  @override
  _FinalScreenState createState() => _FinalScreenState();
}

class _FinalScreenState extends State<FinalScreen> {
  @override
  void initState() {
    super.initState();

    final leaderboardProvider = Provider.of<LeaderboardProvider>(
      context,
      listen: false,
    );

    void errorListener() {
      if (leaderboardProvider.showError) {
        showErrorDialog(context);
        leaderboardProvider.resetErrorFlag();
      }
    }

    leaderboardProvider.addListener(errorListener);
  }

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.only(
                          top: 36,
                          left: MarginsRaw.regular,
                          right: MarginsRaw.regular),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: MarginsRaw.small),
                              child: Consumer<LeaderboardProvider>(
                                  builder: (context, provider, child) {
                                return Text(
                                  provider.tournamentName!,
                                  style: TextStyle(fontSize: 28),
                                );
                              }),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsScreen()),
                              );
                            },
                            child: Icon(
                              Icons.settings,
                              color: Colors.black38,
                            ),
                          )
                        ],
                      ),
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
                            bottom: MarginsRaw.regular),
                        child: Text(
                          AppLocalizations.translate(context, 'winner_title',),
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Consumer<LeaderboardProvider>(
                        builder: (context, provider, child) {
                          return Align(
                            alignment: FractionalOffset.topLeft,
                            child: Padding(
                              padding: Margins.regular,
                              child: Text(
                                provider.leaderboardPlayers.isNotEmpty
                                    ? "${provider.leaderboardPlayers.first.name} 🎉"
                                    : AppLocalizations.translate(context, 'winner_error_message',),

                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.bold),
                                key: winnerTextKey,
                              ),
                            ),
                          );
                        },
                      ),
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
                                  key: tournamentEndedLeaderboardButtonKey,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChangeNotifierProvider<
                                            LeaderboardProvider>.value(
                                          value:
                                              Provider.of<LeaderboardProvider>(
                                            context,
                                            listen: false,
                                          ),
                                          child: LeaderboardScreen(
                                              isFromFinalScreen: true),
                                        ),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        MarginsRaw.borderRadius),
                                    side: BorderSide(color: AppColors.blue),
                                  ),
                                  color: AppColors.blue,
                                  textColor: Colors.white,
                                  padding: Margins.regular,
                                  child: Text(
                                    AppLocalizations.translate(context, 'leaderboard',),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ChangeNotifierProvider(
                                          create: (context) => SetupProvider(),
                                          child: SetupPagesContainer(),
                                        );
                                      },
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      MarginsRaw.borderRadius),
                                  side: BorderSide(color: AppColors.blue),
                                ),
                                color: AppColors.blue,
                                textColor: Colors.white,
                                padding: Margins.regular,
                                child: Text(
                                  AppLocalizations.translate(context, 'new_tournament_button',),
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
        ),
      ),
    );
  }
}
