import 'dart:async';

import 'package:rxdart/rxdart.dart';

class SetupBloc {

  /* *************
  *
  * Stream Stuff
  *
  * ************** */

  // Controllers of input and output
  final _playersNumberController = BehaviorSubject<int>();
  final _playersAstNumberController = StreamController<int>();
  final _matchesNumberController = StreamController<int>();
  final _tournamentNameController = StreamController<String>();


  // Input
  Sink<int> get  setPlayersNumber => _playersNumberController.sink;
  Sink<int> get setPlayersAstNumber => _playersAstNumberController.sink;
  Sink<int> get setMatchesNumber => _matchesNumberController.sink;
  Sink<String> get setTournamentName => _tournamentNameController.sink;

  // Output
  Stream<int> get getPlayersNumber => _playersNumberController.stream;
  Stream<int> get getMatchesNumber => _matchesNumberController.stream;

 /* *************
  *
  * Constructor/Destructor
  *
  * ************** */

  SetupBloc() {
    _playersNumberController.stream.listen(_setPlayersNumber);
    _playersAstNumberController.stream.listen(_setPlayersAstNumber);
    _matchesNumberController.stream.listen(_setMatchesNumber);
    _tournamentNameController.stream.listen(_setTournamentName);
  }

  void dispose() {
    _playersNumberController.close();
    _playersAstNumberController.close();
    _matchesNumberController.close();
    _tournamentNameController.close();
  }

 /* *************
  *
  * Status Variables
  *
  * ************** */
  int _playersNumber;
  int _playersAstNumber;
  int _matchesNumber;
  String _tournamentName;

  /* *************
  *
  * Field handling
  *
  * ************** */
  void _setPlayersNumber(int value) {
    _playersNumber = value;
  }

  void _setPlayersAstNumber(int value) {
    _playersAstNumber = value;
  }

  void _setMatchesNumber(int value) {
    _matchesNumber = value;
  }

  void _setTournamentName(String value) {
    _tournamentName = value;
  }
}