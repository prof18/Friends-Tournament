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
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/data/model/app/end_match_result.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/error_dialog.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/tournament/end_tournament_dialog.dart';
import 'package:friends_tournament/src/views/tournament/session_item_widget.dart';
import 'package:provider/provider.dart';

class SessionScoreView extends StatefulWidget {
  final List<UISession> sessions;
  final AnimationController controller;

  SessionScoreView({this.sessions, this.controller});

  @override
  _SessionScoreViewState createState() => _SessionScoreViewState();
}

class _SessionScoreViewState extends State<SessionScoreView> {
  bool _panelExpanded = false;

  bool hideFab = false;

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener((status) {
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
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          setState(() {
            hideFab = false;
          });
          break;
        case ScrollDirection.reverse:
          setState(() {
            hideFab = true;
          });
          break;
        case ScrollDirection.idle:
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
          opacity: _panelExpanded || hideFab ? 0.0 : 1.0,
          duration: Duration(milliseconds: 100),
          child: Consumer<TournamentProvider>(
            builder: (context, provider, child) {
              return FloatingActionButton(
                backgroundColor: AppColors.blue,
                key: saveFabKey,
                onPressed: () {
                  _showSaveDialog(provider, provider.currentMatch.isActive == 0,
                      provider.currentMatch.name);
                },
                child: provider.currentMatch != null
                    ? provider.currentMatch.isActive == 0
                        ? Icon(Icons.edit)
                        : Icon(Icons.save)
                    : Container(),
              );
            },
          )),
      body: renderBody(context),
    );
  }

  Widget renderBody(BuildContext context) {
    return Container(
      color: AppColors.blue,
      child: Container(
        decoration: new BoxDecoration(
          color: hexToColor("#eeeeee"),
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: widget.sessions.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Padding(
                padding: index == widget.sessions.length - 1
                    ? const EdgeInsets.only(
                        bottom: MarginsRaw.large,
                      )
                    : const EdgeInsets.all(0.0),
                child: SessionItemWidget(
                  session: widget.sessions[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showSaveDialog(TournamentProvider provider, bool isEdit, String matchName) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(MarginsRaw.borderRadius),
            ),
          ),
          title: Text(matchName),
          content: Container(
            height: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: SvgPicture.asset(
                    'assets/save-art.svg',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: MarginsRaw.regular),
                  child: Text(
                    AppLocalizations.of(context).translate(isEdit
                        ? "match_score_update_message"
                        : "match_score_save_message"),
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
              key: saveScoreOkKey,
              child: Text(AppLocalizations.of(context).translate('generic_ok')),
              onPressed: () async {
                EndMatchStatus status = await provider.endMatch();
                if (status == EndMatchStatus.end_tournament) {
                  Navigator.of(context)?.pop();
                  showEndTournamentDialog(
                    context,
                    provider,
                    AppLocalizations.of(context)
                        .translate('finish_tournament_message'),
                  );
                } else if (status == EndMatchStatus.error) {
                  Navigator.of(context)?.pop();
                  showErrorDialog(context);
                } else {
                  Navigator.of(context)?.pop();
                } // TODO: check also error?
              },
            )
          ],
        );
      },
    );
  }
}
