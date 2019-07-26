import 'dart:async';

import 'package:friends_tournament/src/data/setup_repository.dart';
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
  final _matchesNumberController = BehaviorSubject<int>();
  final _tournamentNameController = StreamController<String>();
  final _playersNameController = BehaviorSubject<Map<int, String>>();
  final _matchesNameController = BehaviorSubject<Map<int, String>>();

  // Input
  Sink<int> get setPlayersNumber => _playersNumberController.sink;

  Sink<int> get setPlayersAstNumber => _playersAstNumberController.sink;

  Sink<int> get setMatchesNumber => _matchesNumberController.sink;

  Sink<String> get setTournamentName => _tournamentNameController.sink;

  Sink<Map<int, String>> get setPlayersName => _playersNameController.sink;

  Sink<Map<int, String>> get setMatchesName => _matchesNameController.sink;

  // Output
  Stream<int> get getPlayersNumber => _playersNumberController.stream;

  Stream<int> get getMatchesNumber => _matchesNumberController.stream;

  Stream<Map<int, String>> get getPlayersName => _playersNameController.stream;

  Stream<Map<int, String>> get getMatchesName => _matchesNameController.stream;

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
    _playersNameController.stream.listen(_setPlayersName);
    _matchesNameController.stream.listen(_setMatchesName);
  }

  void dispose() {
    _playersNumberController.close();
    _playersAstNumberController.close();
    _matchesNumberController.close();
    _tournamentNameController.close();
    _playersNameController.close();
    _matchesNameController.close();
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
  Map<int, String> _playersName;
  Map<int, String> _matchesName;

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

  void _setPlayersName(Map<int, String> value) {
    _playersName = value;
  }

  void _setMatchesName(Map<int, String> value) {
    _matchesName = value;
  }

  void setupTournament() {
    SetupRepository repository = new SetupRepository();
    repository.setupTournament(_playersNumber, _playersAstNumber,
        _matchesNumber, _tournamentName, _playersName, _matchesName);
  }
}
