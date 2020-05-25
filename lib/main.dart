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
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
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
    DatabaseProvider databaseProvider = DatabaseProviderImpl.get;
    LocalDataSource localDataSource = LocalDataSource(databaseProvider);
    var repository = TournamentRepository(localDataSource);
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
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: _isLoading
                ? buildLoader()
                : _isActive ? TournamentScreen() : Welcome()),
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
      child: TournamentScreen(),
    );
  }
}
