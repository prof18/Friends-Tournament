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
import 'package:friends_tournament/src/data/errors.dart';
import 'package:friends_tournament/src/provider/leaderboard_provider.dart';
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/custom_icons_icons.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/error_reporting.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/tournament/end_tournament_dialog.dart';
import 'package:friends_tournament/src/views/tournament/leaderboard_page.dart';
import 'package:provider/provider.dart';

import 'error_dialog.dart';

class Backdrop extends StatefulWidget {
  final Widget dropdownWidget;
  final Widget contentWidget;
  final AnimationController controller;

  @override
  State<Backdrop> createState() => _BackdropState();

  const Backdrop(this.dropdownWidget, this.contentWidget, this.controller,
      {Key? key})
      : super(key: key);
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const _panelHeaderHeight = 32.0;

  bool _panelExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        setState(() {
          _panelExpanded = true;
        });
      } else if (status == AnimationStatus.forward) {
        setState(() {
          _panelExpanded = false;
        });
      }
    });
  }

  bool get _isPanelVisible {
    var status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final top = height - _panelHeaderHeight;
    const bottom = -_panelHeaderHeight;
    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
      end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0.0,
        title: _buildMatchNameTitle(),
        leading: _buildMenuButton(),
        actions: <Widget>[
          _buildShowLeaderboardButton(context),
          _buildFinishTournamentButton(context),
        ],
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }

  Widget _buildMatchNameTitle() {
    return AnimatedOpacity(
      opacity: _panelExpanded ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Consumer<TournamentProvider>(
        builder: (context, provider, child) {
          return provider.currentMatch != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(provider.currentMatch!.name),
                )
              : Container();
        },
      ),
    );
  }

  Widget _buildMenuButton() {
    return IconButton(
      key: matchViewButtonKey,
      onPressed: () {
        _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.close_menu,
        progress: _controller.view,
      ),
    );
  }

  Widget _buildShowLeaderboardButton(BuildContext context) {
    return Visibility(
      visible: !_panelExpanded,
      child: IconButton(
        icon: const Icon(CustomIcons.podium),
        key: leaderboardButtonKey,
        onPressed: () {
          final tournament = Provider.of<TournamentProvider>(
            context,
            listen: false,
          ).activeTournament;

          if (tournament == null) {
            reportError(
              ActiveTournamentNullException(),
              null,
              "Error while clicking to show the leaderboard",
            );
            showErrorDialog(context, mounted);
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => LeaderboardProvider(tournament!),
                child: const LeaderboardScreen(isFromFinalScreen: false),
              ),
            ),
          );
        },
        tooltip: AppLocalizations.translate(
          context,
          'show_leaderboard_tooltip',
        ),
      ),
    );
  }

  Widget _buildFinishTournamentButton(BuildContext context) {
    return Visibility(
      visible: !_panelExpanded,
      child: IconButton(
        icon: const Icon(CustomIcons.flagCheckered),
        onPressed: () {
          showEndTournamentDialog(
            context,
            Provider.of<TournamentProvider>(context, listen: false),
            AppLocalizations.translate(context, 'finish_tournament_message'),
            mounted,
          );
        },
        tooltip: AppLocalizations.translate(
          context,
          'finish_tournament_tooltip',
        ),
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final animation = _getPanelAnimation(constraints);
    return Container(
      color: AppColors.blue,
      child: Stack(
        children: <Widget>[
          widget.dropdownWidget,
          PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              elevation: 12.0,
              child: widget.contentWidget,
            ),
          )
        ],
      ),
    );
  }
}
