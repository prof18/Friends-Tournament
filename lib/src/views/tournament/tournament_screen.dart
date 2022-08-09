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
import 'package:flutter/services.dart';
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/backdrop.dart';
import 'package:friends_tournament/src/ui/center_loader.dart';
import 'package:friends_tournament/src/ui/error_dialog.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/tournament/match_selection_tile.dart';
import 'package:friends_tournament/src/views/tournament/session_score_view.dart';
import 'package:provider/provider.dart';

class TournamentScreen extends StatefulWidget {
  TournamentScreen();

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen>
    with SingleTickerProviderStateMixin {
 late AnimationController _controller;

  String? matchName;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );

    final tournamentProvider = Provider.of<TournamentProvider>(
      context,
      listen: false,
    );

    matchName = tournamentProvider.currentMatch != null
        ? tournamentProvider.currentMatch!.name
        : null;

    tournamentProvider.addListener(() {
      if (tournamentProvider.showTournamentInitError) {
        showErrorDialog(context);
        tournamentProvider.resetErrorTrigger();
      }

      final newMatchName = tournamentProvider.currentMatch != null
          ? tournamentProvider.currentMatch!.name
          : null;

      if (matchName == null) {
        this.matchName = newMatchName;
      } else if (newMatchName != this.matchName) {
        this.matchName = newMatchName;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Match \"$matchName\" selected."),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.blue,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Material(
          child: buildBody(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: <Widget>[
        Backdrop(_buildDropdownWidget(), _buildContentWidget(), _controller),
      ],
    );
  }

  Widget _buildDropdownWidget() {
    return Consumer<TournamentProvider>(
      builder: (context, provider, child) {
        return provider.tournamentMatches.isNotEmpty
            ? ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return MatchSelectionTile(
                    key: getKeyForMatchSelector(index),
                    match: provider.tournamentMatches[index],
                    controller: _controller,
                  );
                },
                itemCount: provider.tournamentMatches.length,
              )
            : renderCenterLoader();
      },
    );
  }

  Widget _buildContentWidget() {
    return Consumer<TournamentProvider>(
      builder: (context, provider, child) {
        return provider.currentMatch != null
            ? SessionScoreView(
                sessions: provider.currentMatch!.matchSessions,
                controller: _controller,
              )
            : renderCenterLoader();
      },
    );
  }
}
