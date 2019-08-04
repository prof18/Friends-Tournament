import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/views/backdrop.dart';

class TournamentScreen extends StatefulWidget {
  final bool _isSetup;

  TournamentScreen(this._isSetup);

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  var _isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
      )
    );
  }

  Widget buildBody() {
    return Center(
      child: Backdrop(),
    );
  }
}
