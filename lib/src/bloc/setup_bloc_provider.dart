import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';

class SetupBlocProvider extends InheritedWidget {
  final SetupBloc setupBloc;

  SetupBlocProvider({Key key, SetupBloc setupBloc, Widget child})
      : setupBloc = setupBloc ?? SetupBloc(),
        super(key: key, child: child);

  // If returns true, updates all the depends elements
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static SetupBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(SetupBlocProvider)
              as SetupBlocProvider)
          .setupBloc;
}