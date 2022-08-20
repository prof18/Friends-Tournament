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
import 'package:friends_tournament/src/provider/setup_provider.dart';
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/dialog_loader.dart';
import 'package:friends_tournament/src/ui/error_dialog.dart';
import 'package:friends_tournament/src/ui/slide_dots.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/setup/_1_tournament_name.dart';
import 'package:friends_tournament/src/views/setup/_2_player_number.dart';
import 'package:friends_tournament/src/views/setup/_3_player_ast_number.dart';
import 'package:friends_tournament/src/views/setup/_5_players_name.dart';
import 'package:friends_tournament/src/views/setup/_6_matches_name.dart';
import 'package:friends_tournament/src/views/setup/setup_page.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';
import 'package:provider/provider.dart';

import '_4_matches_number.dart';

/// Adapted from https://github.com/CODEHOMIE/Flutter-Onboarding-UI-Concept/blob/master/lib/ui_view/slider_layout_view.dart
class SetupPagesContainer extends StatefulWidget {
  const SetupPagesContainer({Key? key}) : super(key: key);

  @override
  State<SetupPagesContainer> createState() => _SetupPagesContainerState();
}

class _SetupPagesContainerState extends State<SetupPagesContainer>
    with SingleTickerProviderStateMixin {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final TextEditingController tournamentTextController =
      TextEditingController();

  final List<SetupPage> _allPages = [
    TournamentName(),
    const PlayersNumber(),
    const PlayersAST(),
    const MatchesNumber(),
    PlayersName(),
    MatchesName(),
  ];

  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _controller!.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: MarginsRaw.xlarge),
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        key: setupBackButtonKey,
                        customBorder: const CircleBorder(),
                        onTap: () {
                          final page = _allPages[_currentPageIndex];
                          final canGoBack = page.onBackPressed(context);
                          if (canGoBack) {
                            FocusScope.of(context).unfocus();
                            _pageController.animateToPage(
                                _currentPageIndex -= 1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: MarginsRaw.regular,
                              bottom: MarginsRaw.medium,
                              top: MarginsRaw.medium,
                              right: MarginsRaw.medium),
                          child: Text(
                            AppLocalizations.translate(
                              context,
                              'generic_back',
                            ),
                            style: AppTextStyle.textStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      key: setupNextButtonKey,
                      customBorder: const CircleBorder(),
                      onTap: () {
                        final page = _allPages[_currentPageIndex];
                        final canGoForward = page.onNextPressed(context);
                        if (canGoForward) {
                          if (_currentPageIndex != _allPages.length - 1) {
                            FocusScope.of(context).unfocus();
                            _pageController.animateToPage(
                                _currentPageIndex += 1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease);
                          } else {
                            _showAlertDialog();
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: MarginsRaw.regular,
                            bottom: MarginsRaw.medium,
                            top: MarginsRaw.medium,
                            left: MarginsRaw.medium),
                        child: Text(
                          AppLocalizations.translate(
                            context,
                            _currentPageIndex == _allPages.length - 1
                                ? "generic_done"
                                : "generic_next",
                          ),
                          style: AppTextStyle.textStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.bottomCenter,
                    margin: const EdgeInsets.only(bottom: MarginsRaw.medium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < _allPages.length; i++)
                          if (i == _currentPageIndex)
                            const SlideDots(true)
                          else
                            const SlideDots(false)
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
    return const Material(
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(MarginsRaw.borderRadius),
            ),
          ),
          title: Text(
            AppLocalizations.translate(
              context,
              'tournament_building_title',
            ),
          ),
          content: Text(
            AppLocalizations.translate(
              context,
              'tournament_building_message',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.translate(
                  context,
                  'generic_cancel',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              key: finishSetupProceedButtonKey,
              child: Text(
                AppLocalizations.translate(
                  context,
                  'tournament_building_go_button',
                ),
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

  _showLoaderAndStartProcess() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DialogLoader(
        controller: _controller,
        text: AppLocalizations.translate(
          context,
          'generating_tournament_message',
        ),
      ),
    );

    final result = await Provider.of<SetupProvider>(context, listen: false)
        .setupTournament();

    if (result) {
      _controller!.reverse().then(
        (_) {
          Navigator.pop(context);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => TournamentProvider(),
                  child: const TournamentScreen(),
                ),
              ),
              (Route<dynamic> route) => false);
        },
      );
    } else {
      if (!mounted) return;
      showErrorDialog(context, mounted);
    }
  }
}
