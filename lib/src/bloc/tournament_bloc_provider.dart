import 'package:flutter/cupertino.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';

class TournamentBlocProvider extends InheritedWidget {
  final TournamentBloc tournamentBloc;

  TournamentBlocProvider({Key key, TournamentBloc tournamentBloc, Widget child})
      : tournamentBloc = tournamentBloc ?? TournamentBloc(),
        super(key: key, child: child);

  // If returns true, updates all the depends elements
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static TournamentBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TournamentBlocProvider)
              as TournamentBlocProvider)
          .tournamentBloc;
}
