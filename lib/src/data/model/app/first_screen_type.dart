import 'package:friends_tournament/src/data/model/db/tournament.dart';

class FirstScreenType {
  FirstScreenType._();

  factory FirstScreenType.loading() = LoadingScreen;
  factory FirstScreenType.welcome() = WelcomeScreen;
  factory FirstScreenType.tournament() = TournamentViewScreen;
  factory FirstScreenType.lastTournamentResult(Tournament tournament) = LastTournamentResultScreen;
}

class LoadingScreen extends FirstScreenType {
  LoadingScreen() : super._();
}

class WelcomeScreen extends FirstScreenType {
  WelcomeScreen() : super._();
}

class TournamentViewScreen extends FirstScreenType {
  TournamentViewScreen() : super._();
}

class LastTournamentResultScreen extends FirstScreenType {
  LastTournamentResultScreen(this.tournament) : super._();

  final Tournament tournament;
}