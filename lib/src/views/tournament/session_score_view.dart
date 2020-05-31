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
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_player.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/tournament/session_item_widget.dart';
import 'package:friends_tournament/style/app_style.dart';

class SessionScoreView extends StatefulWidget {
  final List<UISession> sessions;
  final AnimationController controller;

  SessionScoreView({this.sessions, this.controller});

  @override
  _SessionScoreViewState createState() => _SessionScoreViewState();
}

class _SessionScoreViewState extends State<SessionScoreView> {
  bool _panelExpanded = false;
  TournamentBloc _tournamentBloc;

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
  }

  @override
  Widget build(BuildContext context) {

    _tournamentBloc = TournamentBlocProvider.of(context);

    return Scaffold(
//      backgroundColor: hexToColor("#eeeeee"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedOpacity(
        opacity: _panelExpanded ? 0.0 : 1.0,
        duration: Duration(milliseconds: 100),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MarginsRaw.borderRadius),
              side: BorderSide(color: AppColors.blue)),
          color: AppColors.blue,
          textColor: Colors.white,
          padding: Margins.regular,
          onPressed: () {
            // TODO
            // TODO: show a loader or a popup. Say also that automatically
            // TODO: we skip to the following match
            _tournamentBloc.endMatch().then((_) {
              // TODO: hide the loader and change app state
            });
          },
          child: Text(
            'Finish current match',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: ListView.builder(
            itemCount: widget.sessions.length,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: SessionItemWidget(
                  session: widget.sessions[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/*

ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.sessions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: SessionItemWidget(
                          session: widget.sessions[index],
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Container(
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 8.0,
                    child: StreamBuilder<List<UIPlayer>>(
                      stream: _tournamentBloc.podiumPlayers,
                      builder: (context, snapshot) {
                        return Center(
                          // TODO: make better looking!
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                // TODO: localize
                                Text("Podium of the last match"),
                                snapshot.hasData && snapshot.data.length > 0
                                    ? ListView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Text(
                                              snapshot.data[index].name);
                                        },
                                        itemCount: snapshot.data.length,
                                      )
                                    : Text("No players. Finish first a match"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        )

 */
