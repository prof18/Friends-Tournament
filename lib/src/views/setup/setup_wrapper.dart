import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/views/setup/1_number_setup.dart';

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  SetupBloc setupBloc = SetupBloc();

  @override
  Widget build(BuildContext context) {
    return SetupBlocProvider(
      setupBloc: setupBloc,
      child: NumberSetup(),
    );
  }
}
