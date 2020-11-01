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
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/custom_icons_icons.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/tournament/final_screen.dart';
import 'package:friends_tournament/src/views/tournament/leaderboard_page.dart';

class Backdrop extends StatefulWidget {
  final Widget dropdownWidget;
  final Widget contentWidget;
  final AnimationController controller;

  @override
  _BackdropState createState() => _BackdropState();

  Backdrop(this.dropdownWidget, this.contentWidget, this.controller);
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const _PANEL_HEADER_HEIGHT = 32.0;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TournamentBloc tournamentBloc = TournamentBlocProvider.of(context);

      tournamentBloc.tournamentIsOver.listen((event) {
        _showEndTournamentDialog(
            AppLocalizations.of(context).translate('match_finished_message'));
      });
    });
  }

  bool get _isPanelVisible {
    var status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final top = height - _PANEL_HEADER_HEIGHT;
    final bottom = -_PANEL_HEADER_HEIGHT;
    return RelativeRectTween(
            begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
            end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    TournamentBloc tournamentBloc = TournamentBlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0.0,
        title: AnimatedOpacity(
          opacity: _panelExpanded ? 0.0 : 1.0,
          duration: Duration(milliseconds: 200),
          child: StreamBuilder<UIMatch>(
            stream: tournamentBloc.currentMatch,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(snapshot.data.name),
                    )
                  : Container();
            },
          ),
        ),
        leading: IconButton(
          onPressed: () {
            _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller.view,
          ),
        ),
        actions: <Widget>[
          Visibility(
            visible: !_panelExpanded,
            child: IconButton(
              icon: Icon(CustomIcons.podium),
              onPressed: () async {
                final tournament = await tournamentBloc.activeTournament.first;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaderboardScreen(tournament)),
                );
              },
              tooltip: AppLocalizations.of(context)
                  .translate('show_leaderboard_tooltip'),
            ),
          ),
          Visibility(
            visible: !_panelExpanded,
            child: IconButton(
              icon: Icon(CustomIcons.flag_checkered),
              onPressed: () {
                _showEndTournamentDialog(AppLocalizations.of(context)
                    .translate('finish_tournament_message'));
              },
              tooltip: AppLocalizations.of(context)
                  .translate('finish_tournament_tooltip'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: _buildStack,
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
          new PositionedTransition(
            rect: animation,
            child: new Material(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                elevation: 12.0,
                child: widget.contentWidget),
          )
        ],
      ),
    );
  }

  _showEndTournamentDialog(String message) {
    TournamentBloc tournamentBloc = TournamentBlocProvider.of(context);

    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return StreamBuilder<Tournament>(
          stream: tournamentBloc.activeTournament,
          builder: (context, snapshot) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(MarginsRaw.borderRadius),
                ),
              ),
              title: snapshot.hasData ? Text(snapshot.data.name) : Container(),
              content: Container(
                height: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: SvgPicture.asset(
                        'assets/finish-art.svg',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: MarginsRaw.regular),
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('generic_cancel')),
                  onPressed: () {
                    Navigator.of(context)?.pop();
                  },
                ),
                FlatButton(
                  child: Text(
                      AppLocalizations.of(context).translate('generic_ok')),
                  onPressed: () async {
                    final tournament =
                        await tournamentBloc.activeTournament.first;
                    await tournamentBloc.endTournament();
                    Navigator.of(context)?.pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => TournamentBlocProvider(
                            child: FinalScreen(tournament),
                          ),
                        ),
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
