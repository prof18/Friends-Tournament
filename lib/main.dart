import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';
import 'package:friends_tournament/src/views/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isLoading = true;
  var _isActive = false;

  @override
  void initState() {
    super.initState();

    // TODO: add error handling
    var repository = TournamentRepository();
    repository.isTournamentActive().then((active) {
      setState(() {
        _isActive = active;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SetupBlocProvider(
      child: TournamentBlocProvider(
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: _isLoading
                ? buildLoader()
                : _isActive ? TournamentScreen(false) : Welcome()),
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

  Widget buildWelcomeScreen() {
    return SetupBlocProvider(
      child: Welcome(),
    );
  }

  Widget buildTournamentScreen() {
    return TournamentBlocProvider(
      child: TournamentScreen(false),
    );
  }
}
