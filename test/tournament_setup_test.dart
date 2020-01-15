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

import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tournament/src/data/model/db/match_session.dart';
import 'package:friends_tournament/src/data/model/db/player_session.dart';
import 'package:friends_tournament/src/data/setup_repository.dart';

import 'test_tournament.dart';

void main() {
  group('Tournament Setup Tests', () {
    final SetupRepository setupRepository = SetupRepository();

    test("check tournament data", () {
      assert(TestTournament.playersNumber >= TestTournament.playersAstNumber);
      expect(TestTournament.playersNumber, TestTournament.playersName.length);
      expect(TestTournament.matchesNumber, TestTournament.matchesName.length);
    });

    test("create tournament", () {
      setupRepository.createTournament(
          TestTournament.playersNumber,
          TestTournament.playersAstNumber,
          TestTournament.matchesNumber,
          TestTournament.tournamentName,
          TestTournament.playersName,
          TestTournament.matchesName);
    });

    test("players number is correct", () {
      expect(setupRepository.players.length, TestTournament.playersNumber);
    });

    test("players name are correct", () {
      expect(setupRepository.players[0].name, TestTournament.playersName[0]);
      expect(setupRepository.players[1].name, TestTournament.playersName[1]);
      expect(setupRepository.players[2].name, TestTournament.playersName[2]);
      expect(setupRepository.players[3].name, TestTournament.playersName[3]);
    });

    test("players id are diffent", () {
      final player1Id = setupRepository.players[0].id;
      final player2Id = setupRepository.players[1].id;
      final player3Id = setupRepository.players[2].id;
      final player4Id = setupRepository.players[3].id;

      expect(player1Id, isNot(equals(player2Id)));
      expect(player1Id, isNot(equals(player3Id)));
      expect(player1Id, isNot(equals(player4Id)));

      expect(player2Id, isNot(equals(player3Id)));
      expect(player2Id, isNot(equals(player4Id)));
    });

    test("matcheas number is correct", () {
      expect(setupRepository.matches.length, TestTournament.matchesNumber);
    });

    test("matches id are diffent", () {
      final match1Id = setupRepository.matches[0].id;
      final match2Id = setupRepository.matches[1].id;
      final match3Id = setupRepository.matches[2].id;
      final match4Id = setupRepository.matches[3].id;

      expect(match1Id, isNot(equals(match2Id)));
      expect(match1Id, isNot(equals(match3Id)));
      expect(match1Id, isNot(equals(match4Id)));

      expect(match2Id, isNot(equals(match3Id)));
      expect(match2Id, isNot(equals(match4Id)));
    });

    test('sessions number are correct', () {
      final sessionsNumber =
          TestTournament.matchesNumber / TestTournament.playersAstNumber;
      expect(sessionsNumber * TestTournament.matchesNumber,
          setupRepository.sessions.length);
    });

    test('sessions id are different', () {
      final session1Id = setupRepository.sessions[0].id;
      final session2Id = setupRepository.sessions[1].id;
      final session3Id = setupRepository.sessions[2].id;
      final session4Id = setupRepository.sessions[3].id;
      final session5Id = setupRepository.sessions[4].id;
      final session6Id = setupRepository.sessions[5].id;
      final session7Id = setupRepository.sessions[6].id;
      final session8Id = setupRepository.sessions[7].id;

      expect(session1Id, isNot(equals(session2Id)));
      expect(session1Id, isNot(equals(session3Id)));
      expect(session1Id, isNot(equals(session4Id)));
      expect(session1Id, isNot(equals(session5Id)));
      expect(session1Id, isNot(equals(session6Id)));
      expect(session1Id, isNot(equals(session7Id)));
      expect(session1Id, isNot(equals(session8Id)));

      expect(session2Id, isNot(equals(session3Id)));
      expect(session2Id, isNot(equals(session4Id)));
      expect(session2Id, isNot(equals(session5Id)));
      expect(session2Id, isNot(equals(session6Id)));
      expect(session2Id, isNot(equals(session7Id)));
      expect(session2Id, isNot(equals(session8Id)));

      expect(session3Id, isNot(equals(session4Id)));
      expect(session3Id, isNot(equals(session5Id)));
      expect(session3Id, isNot(equals(session6Id)));
      expect(session3Id, isNot(equals(session7Id)));
      expect(session3Id, isNot(equals(session8Id)));

      expect(session4Id, isNot(equals(session5Id)));
      expect(session4Id, isNot(equals(session6Id)));
      expect(session4Id, isNot(equals(session7Id)));
      expect(session4Id, isNot(equals(session8Id)));

      expect(session5Id, isNot(equals(session6Id)));
      expect(session5Id, isNot(equals(session7Id)));
      expect(session5Id, isNot(equals(session8Id)));

      expect(session6Id, isNot(equals(session7Id)));
      expect(session6Id, isNot(equals(session8Id)));

      expect(session7Id, isNot(equals(session8Id)));
    });

    test(
        "MatchSession: for each match, there should be two session, with two different ids",
        () {
      setupRepository.matches.forEach((match) {
        final List<MatchSession> matchSessionList = setupRepository
            .matchSessionList
            .where((matchSession) => matchSession.matchId == match.id)
            .toList();
        expect(matchSessionList[0].sessionId,
            isNot(equals(matchSessionList[1].sessionId)));
      });
    });

    test(
        "Player Session: for each session there should be two players with different ids",
        () {
      setupRepository.sessions.forEach((session) {
        final List<PlayerSession> playerSessionList = setupRepository
            .playerSessionList
            .where((playerSession) => playerSession.sessionId == session.id)
            .toList();

        expect(playerSessionList[0].playerId,
            isNot(equals(playerSessionList[1].playerId)));
      });
    });

    test("in a match all players have to play", () {

      setupRepository.matches.forEach((match) {

        var uniques = new LinkedHashMap<String, void>();

        final List<MatchSession> matchSessionList = setupRepository
            .matchSessionList
            .where((matchSession) => matchSession.matchId == match.id)
            .toList();

        matchSessionList.forEach((matchSession) {

          final List<PlayerSession> playerSessionList = setupRepository
              .playerSessionList
              .where((playerSession) => playerSession.sessionId == matchSession.sessionId)
              .toList();

          playerSessionList.forEach((playerSession) {
            uniques[playerSession.playerId] = null;
          });

        });
        expect(uniques.length, TestTournament.playersNumber);
      });
    });
  });
}
