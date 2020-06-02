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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';
import 'package:friends_tournament/src/views/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  _loadData() async {
    DatabaseProvider databaseProvider = DatabaseProviderImpl.get;
    LocalDataSource localDataSource = LocalDataSource(databaseProvider);
    var repository = TournamentRepository(localDataSource);

    var isActive = false;
    try {
      isActive = await repository.isTournamentActive();
    } on Exception catch (_) {
      // do nothing, we assume that the tournament is not active
    }

    await precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/intro-art.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/players_art.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/player-ast-art.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/matches-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/podium-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/error-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/finish-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/save-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/winner-art.svg'),
        null);

    setState(() {
      _isActive = isActive;
      _isLoading = false;
    });
  }

  @override
  // TODO: change theme and name
  Widget build(BuildContext context) {
    return SetupBlocProvider(
      child: TournamentBlocProvider(
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: _isLoading
                ? buildLoader()
            // TODO: if none tournament is active, but there are some in the memory, load the last one
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
