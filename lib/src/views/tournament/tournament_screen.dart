import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/ui/backdrop.dart';
import 'package:friends_tournament/src/ui/expanding_bottom_sheet.dart';
import 'package:friends_tournament/src/views/tournament/match_selection_tile.dart';
import 'package:friends_tournament/src/views/tournament/session_carousel.dart';

class TournamentScreen extends StatefulWidget {
  final bool _isSetup;

  TournamentScreen(this._isSetup);

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading = true;
  var _controller;
  var _tournamentBloc;

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget._isSetup) {
      var bloc = SetupBlocProvider.of(context);
      // TODO: add error handling
      bloc.setupTournament().then((_) {
        print("I'm over on saving data on the db");
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _tournamentBloc = TournamentBlocProvider.of(context);

    return Material(
      child: SafeArea(
        child: widget._isSetup
            ? _isLoading ? buildLoader(context) : buildBody()
            : buildBody(),
      ),
    );
  }

  Widget buildLoader(BuildContext context) {
    // TODO: add also some strings to show the insert process and the computing of the tournament data
    return Container(
        child: Center(
      child: CircularProgressIndicator(),
    ));
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

  Widget _buildDropdownWidget() {
    // TODO: implement dropdown widget.
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

  Widget _buildContentWidget() {
    return Carousel();
  }
}
