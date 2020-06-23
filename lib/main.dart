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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/setup_bloc.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/error_reporting.dart';
import 'package:friends_tournament/src/views/tournament/final_screen.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';
import 'package:friends_tournament/src/views/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  // Run the whole app in a zone to capture all uncaught errors.
  runZoned(
    () => runApp(MyApp()),
    onError: (Object error, StackTrace stackTrace) {
      try {
        reportError(error, stackTrace);
        print('Error sent to sentry.io: $error');
      } catch (e) {
        print('Sending report to sentry.io failed: $e');
        print('Original error: $error');
      }
    },
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isLoading = true;
  var _isActive = false;
  Tournament _lastTournament;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }


  @override
  void dispose() {
    TournamentBloc tournamentBloc = TournamentBlocProvider.of(context);
    SetupBloc setupBloc = SetupBlocProvider.of(context);

    tournamentBloc.dispose();
    setupBloc.dispose();

    super.dispose();
  }

  _loadData() async {
    DatabaseProvider databaseProvider = DatabaseProviderImpl.get;
    LocalDataSource localDataSource = LocalDataSource(databaseProvider);
    final repository = TournamentRepository(localDataSource);

    var isActive = false;
    try {
      isActive = await repository.isTournamentActive();
      if (!isActive) {
        _lastTournament = await repository.getLastFinishedTournament();
      }
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
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/podium-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/error-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/finish-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/save-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/winner-art.svg'),
        null);

    setState(() {
      _isActive = isActive;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SetupBlocProvider(
      child: TournamentBlocProvider(
        child: MaterialApp(
          title: 'Friends Tournament',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.montserratTextTheme(
              Theme.of(context).textTheme,
            ),
          ),

          supportedLocales: [
            Locale('en', 'US'),
            Locale('it', 'IT'),
          ],
          // These delegates make sure that the localization data for the proper language is loaded
          localizationsDelegates: [
            // A class which loads the translations from JSON files
            AppLocalizations.delegate,
            // Built-in localization of basic text for Material widgets
            GlobalMaterialLocalizations.delegate,
            // Built-in localization for text direction LTR/RTL
            GlobalWidgetsLocalizations.delegate,
          ],
          // Returns a locale which will be used by the app
          localeResolutionCallback: (locale, supportedLocales) {
            // Check if the current device locale is supported
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }
            // If the locale of the device is not supported, use the first one
            // from the list (English, in this case).
            return supportedLocales.first;
          },
          home: _isLoading
              ? buildLoader()
              : _isActive ? _buildTournamentScreen() : _buildWelcomeScreen(),
        ),
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

  Widget _buildWelcomeScreen() {
    return _lastTournament != null ? FinalScreen(_lastTournament) : Welcome();
  }

  Widget _buildTournamentScreen() {
    return TournamentScreen();
  }
}
