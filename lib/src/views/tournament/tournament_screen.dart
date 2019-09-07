import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/ui/backdrop.dart';
import 'package:friends_tournament/src/ui/expanding_bottom_sheet.dart';
import 'package:friends_tournament/src/views/tournament/match_selection_tile.dart';
import 'package:friends_tournament/src/views/tournament/session_carousel.dart';

class TournamentScreen extends StatefulWidget {
  TournamentScreen();

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TournamentBloc _tournamentBloc;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _tournamentBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tournamentBloc = TournamentBlocProvider.of(context);

    return Material(
      child: SafeArea(
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: <Widget>[
        Backdrop(_buildDropdownWidget(), _buildContentWidget(), _controller),
        Align(
            child: ExpandingBottomSheet(hideController: _controller),
            alignment: Alignment.bottomRight),
      ],
    );
  }

  // TODO: add a loader
  Widget _buildDropdownWidget() {
    return StreamBuilder<List<UIMatch>>(
      initialData: List<UIMatch>(),
      stream: _tournamentBloc.tournamentMatches,
      builder: (context, snapshot) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return MatchSelectionTile(
              match: snapshot.data[index],
              controller: _controller,
            );
          },
          itemCount: snapshot.data.length,
        );
      },
    );
  }

  // TODO: add a loader
  Widget _buildContentWidget() {
    return StreamBuilder<UIMatch>(
      stream: _tournamentBloc.currentMatch,
      builder: (context, snapshot) {
        return SessionCarousel(
          sessions: snapshot.hasData
              ? snapshot.data.matchSessions
              : List<UISession>(),
          controller: _controller,
        );
      },
    );
  }
}
