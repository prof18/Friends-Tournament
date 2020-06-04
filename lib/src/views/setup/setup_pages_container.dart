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
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/dialog_loader.dart';
import 'package:friends_tournament/src/ui/error_dialog.dart';
import 'package:friends_tournament/src/ui/slide_dots.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/setup/1_tournament_name.dart';
import 'package:friends_tournament/src/views/setup/2_player_number.dart';
import 'package:friends_tournament/src/views/setup/3_player_ast_number.dart';
import 'package:friends_tournament/src/views/setup/5_players_name.dart';
import 'package:friends_tournament/src/views/setup/6_matches_name.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';

import '4_matches_number.dart';

/// Adapted from https://github.com/CODEHOMIE/Flutter-Onboarding-UI-Concept/blob/master/lib/ui_view/slider_layout_view.dart
class SetupPagesContainer extends StatefulWidget {
  @override
  _SetupPagesContainerState createState() => _SetupPagesContainerState();
}

class _SetupPagesContainerState extends State<SetupPagesContainer>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final TextEditingController tournamentTextController =
      TextEditingController();

  List<SetupPage> _allPages;

  SetupBloc _setupBloc;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setupBloc = SetupBlocProvider.of(context);

      _setupBloc.getErrorChecker.listen((event) {
        showErrorDialog(context);
      });

      setState(() {
        _allPages = <SetupPage>[
          TournamentName(_setupBloc),
          PlayersNumber(_setupBloc),
          PlayersAST(_setupBloc),
          MatchesNumber(_setupBloc),
          PlayersName(_setupBloc),
          MatchesName(_setupBloc)
        ];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _setupBloc.dispose();
    _pageController.dispose();
    _controller.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _allPages == null
        ? buildLoader()
        : AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
              body: Container(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 42.0),
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: _allPages.length,
                        itemBuilder: (ctx, i) => _allPages[i],
                      ),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Visibility(
                          visible: _currentPageIndex != 0,
                          child: GestureDetector(
                            onTap: () {
                              final page = _allPages[_currentPageIndex];
                              final canGoBack = page.onBackPressed();
                              if (canGoBack) {
                                if (_currentPageIndex != _allPages.length - 1) {
                                  FocusScope.of(context).unfocus();
                                  _pageController.animateToPage(
                                      _currentPageIndex -= 1,
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.ease);
                                }
                              }
                            },
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 15.0, bottom: 15.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('generic_back'),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            onTap: () {
                              final page = _allPages[_currentPageIndex];
                              final canGoForward = page.onNextPressed(context);
                              if (canGoForward) {
                                if (_currentPageIndex != _allPages.length - 1) {
                                  FocusScope.of(context).unfocus();
                                  _pageController.animateToPage(
                                      _currentPageIndex += 1,
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.ease);
                                } else {
                                  _showAlertDialog();
                                }
                              }
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: 15.0, bottom: 15.0),
                              child: Text(
                                AppLocalizations.of(context).translate(
                                    _currentPageIndex == _allPages.length - 1
                                        ? "generic_done"
                                        : "generic_next"),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          alignment: AlignmentDirectional.bottomCenter,
                          margin: EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for (int i = 0; i < _allPages.length; i++)
                                if (i == _currentPageIndex)
                                  SlideDots(true)
                                else
                                  SlideDots(false)
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildLoader() {
    return Material(
      child: SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  _showAlertDialog() {
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
          title: Text(
            AppLocalizations.of(context).translate('tournament_building_title'),
          ),
          content: Text(
            AppLocalizations.of(context)
                .translate('tournament_building_message'),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                  AppLocalizations.of(context).translate('generic_cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context)
                    .translate('tournament_building_go_button'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showLoaderAndStartProcess();
              },
            )
          ],
        );
      },
    );
  }

  _showLoaderAndStartProcess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogLoader(
        controller: _controller,
        text: AppLocalizations.of(context)
            .translate('generating_tournament_message'),
      ),
    );

    _setupBloc.setupTournament().then(
      (_) {
        _controller.reverse().then(
          (_) {
            _setupBloc.dispose();
            Navigator.pop(context);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TournamentBlocProvider(
                    child: TournamentScreen(),
                  ),
                ),
                (Route<dynamic> route) => false);
          },
        );
      },
    );
  }
}
