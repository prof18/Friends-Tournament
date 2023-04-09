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
import 'package:friends_tournament/src/ui/chip_separator.dart';
import 'package:friends_tournament/src/ui/error_dialog.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/is_tablet.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/settings/settings_screen.dart';
import 'package:friends_tournament/src/views/setup/setup_pages_container.dart';
import 'package:friends_tournament/src/views/tournament/leaderboard_page.dart';
import 'package:provider/provider.dart';

class FinalScreen extends StatefulWidget {
  const FinalScreen({Key? key}) : super(key: key);

  @override
  State<FinalScreen> createState() => _FinalScreenState();
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
        showErrorDialog(context, mounted);
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
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Padding(
          padding:  EdgeInsets.only(
            left: isTablet(context) ? MarginsRaw.medium : MarginsRaw.regular,
            right: isTablet(context) ? MarginsRaw.medium : MarginsRaw.regular,
            bottom: isTablet(context) ? MarginsRaw.medium : MarginsRaw.regular,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildNavigationBar(context),
                    Expanded(
                      flex: 7,
                      child: _buildImage(),
                    ),
                    _buildChipSeparator(),
                    _buildWinnerTitle(context),
                    Expanded(
                      flex: 3,
                      child: _buildWinnerText(),
                    ),
                    _buildButtonRow(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 36,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: MarginsRaw.small),
              child: Consumer<LeaderboardProvider>(
                builder: (context, provider, child) {
                  return Text(
                    provider.tournamentName!,
                    style: AppTextStyle.textStyle(fontSize: 28),
                  );
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.settings,
              color: Colors.black38,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Center(
        child: SvgPicture.asset('assets/winner-art.svg'),
    );
  }

  Widget _buildChipSeparator() {
    return const Padding(
      padding: EdgeInsets.only(
        top: MarginsRaw.regular,
      ),
      child: ChipSeparator(),
    );
  }

  Widget _buildWinnerTitle(BuildContext context) {
    return Align(
      alignment: FractionalOffset.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: isTablet(context) ? MarginsRaw.large : MarginsRaw.medium,
          bottom: MarginsRaw.regular,
        ),
        child: Text(
          AppLocalizations.translate(context, 'winner_title'),
          style: AppTextStyle.textStyle(fontSize: 28),
        ),
      ),
    );
  }

  Widget _buildWinnerText() {
    return Consumer<LeaderboardProvider>(
      builder: (context, provider, child) {
        return Align(
          alignment: FractionalOffset.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              top: MarginsRaw.regular,
              bottom: MarginsRaw.regular,
            ),
            child: Text(
              provider.leaderboardPlayers.isNotEmpty
                  ? "${provider.leaderboardPlayers.first.name} 🎉"
                  : AppLocalizations.translate(context, 'winner_error_message'),
              style: AppTextStyle.textStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              key: winnerTextKey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          top: MarginsRaw.regular,
          bottom: MarginsRaw.regular,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: MarginsRaw.regular),
                child: _buildLeaderboardButton(context),
              ),
            ),
            Expanded(
              child: _buildNewTournamentButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardButton(BuildContext context) {
    return ElevatedButton(
      key: tournamentEndedLeaderboardButtonKey,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<LeaderboardProvider>.value(
              value: Provider.of<LeaderboardProvider>(
                context,
                listen: false,
              ),
              child: const LeaderboardScreen(isFromFinalScreen: true),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MarginsRaw.borderRadius),
          side: BorderSide(color: AppColors.blue),
        ),
        backgroundColor: AppColors.blue,
        textStyle: AppTextStyle.textStyle(color: Colors.white),
        padding: Margins.regular,
      ),
      child: Text(
        AppLocalizations.translate(context, 'leaderboard'),
        style: AppTextStyle.textStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildNewTournamentButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => SetupProvider(),
                child: const SetupPagesContainer(),
              );
            },
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MarginsRaw.borderRadius),
          side: BorderSide(color: AppColors.blue),
        ),
        backgroundColor: AppColors.blue,
        textStyle: AppTextStyle.textStyle(color: Colors.white),
        padding: Margins.regular,
      ),
      child: Text(
        AppLocalizations.translate(context, 'new_tournament_button'),
        style: AppTextStyle.textStyle(fontSize: 16),
      ),
    );
  }
}
