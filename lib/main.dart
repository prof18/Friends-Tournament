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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:friends_tournament/firebase_options.dart';
import 'package:friends_tournament/src/data/model/app/first_screen_type.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/provider/leaderboard_provider.dart';
import 'package:friends_tournament/src/provider/main_provider.dart';
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/ui/center_loader.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/error_reporting.dart';
import 'package:friends_tournament/src/views/tournament/final_screen.dart';
import 'package:friends_tournament/src/views/tournament/tournament_screen.dart';
import 'package:friends_tournament/src/views/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(const MyApp());
  }, (error, stack) {
    if (!isInDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainProvider(),
      child: MaterialApp(
        title: 'Friends Tournament',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),

        supportedLocales: const [
          Locale('en', ''),
          Locale('it', ''),
          Locale('pt', ''),
          Locale('es', ''),
          Locale('fr', ''),
        ],
        // These delegates make sure that the localization data for the proper language is loaded
        localizationsDelegates: const [
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
            if (supportedLocale.languageCode == locale!.languageCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        home: _buildHome(),
      ),
    );
  }

  Widget _buildHome() {
    return Consumer<MainProvider>(builder: (context, provider, child) {
      final screen = provider.firstScreenType;
      if (screen is LoadingScreen) {
        return renderCenterLoader();
      } else if (screen is WelcomeScreen) {
        return const Welcome();
      } else if (screen is TournamentViewScreen) {
        return _buildTournamentScreen();
      } else if (screen is LastTournamentResultScreen) {
        final tournament = screen.tournament;
        return _buildFinalScreen(tournament);
      } else {
        // fallback, should never happen!
        return const Welcome();
      }
    });
  }

  Widget _buildFinalScreen(Tournament lastTournament) {
    return ChangeNotifierProvider(
      create: (context) => LeaderboardProvider(lastTournament),
      child: const FinalScreen(),
    );
  }

  Widget _buildTournamentScreen() {
    return ChangeNotifierProvider(
      create: (context) => TournamentProvider(),
      child: const TournamentScreen(),
    );
  }
}
