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

import 'dart:async';

import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/setup_repository.dart';
import 'package:friends_tournament/src/utils/error_reporting.dart';
import 'package:rxdart/rxdart.dart';

class SetupBloc {
  /* *************
  *
  * Stream Stuff
  *
  * ************** */

  // Controllers of input and output
  // Behaviour subjects emits the latest item when a new listener is added
  final _playersNumberController = BehaviorSubject<int>();
  final _playersAstNumberController = BehaviorSubject<int>();
  final _matchesNumberController = BehaviorSubject<int>();
  final _tournamentNameController = StreamController<String>();
  final _playersNameController = BehaviorSubject<Map<int, String>>();
  final _matchesNameController = BehaviorSubject<Map<int, String>>();
  final _errorController = BehaviorSubject<void>();

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

  Stream<int> get getPlayersAstNumber => _playersAstNumberController.stream;

  Stream<Map<int, String>> get getPlayersName => _playersNameController.stream;

  Stream<Map<int, String>> get getMatchesName => _matchesNameController.stream;

  Stream<void> get getErrorChecker => _errorController.stream;

  /* *************
  *
  * Constructor/Destructor
  *
  * ************** */

  SetupBloc() {
    // Default values

    /// The min value for a meaningful tournament is two players
    _playersNumberController.value = 2;

    /// The min value for a meaningful match is two players
    _playersAstNumberController.value = 2;

    /// The min value for a meaningful tournament is one
    _matchesNumberController.value = 1;

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
    _errorController.close();
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

  int getCurrentPlayersNumber() => _playersNumber != null ? _playersNumber : 0;

  int getCurrentPlayersAstNumber() =>
      _playersAstNumber != null ? _playersAstNumber : 2;

  Future<bool> setupTournament() async {
    DatabaseProvider databaseProvider = DatabaseProviderImpl.get;
    LocalDataSource localDataSource = LocalDataSource(databaseProvider);
    SetupRepository repository = new SetupRepository(localDataSource);

    try {
      await repository.setupTournament(_playersNumber, _playersAstNumber,
          _matchesNumber, _tournamentName, _playersName, _matchesName);
      return true;
    } catch (error, stackTrace) {
      /// We know these exceptions:
      ///  - MatchesWithSameIdException
      ///  - TooMuchPlayersASTException -> do not start setup process from scratch
      ///  - AlreadyActiveTournamentException -> it should never happen! A setup process never starts if there is another ongoing tournament
      await reportError(error, stackTrace);
      _errorController.add(null);
      return false;
    }
  }

  void clearAll() {
    _playersNumber = null;
    _playersAstNumber = null;
    _matchesNumber = null;
    _tournamentName = null;
    _playersName = null;
    _matchesName = null;

    /// The min value for a meaningful tournament is two players
    _playersNumberController.value = 2;

    /// The min value for a meaningful match is two players
    _playersAstNumberController.value = 2;

    /// The min value for a meaningful tournament is one
    _matchesNumberController.value = 1;
  }
}
