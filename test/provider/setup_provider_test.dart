import 'package:flutter_test/flutter_test.dart';
import 'package:friends_tournament/src/provider/setup_provider.dart';

void main() {
  group('SetupProvider tests ->', () {
    test('When calling setPlayersNumber, the players number is updated', () {
      final provider = SetupProvider();
      final playersNumber = provider.playersNumber;
      provider.addListener(() {
        expect(provider.playersNumber, 3);
      });

      expect(playersNumber, 2);

      provider.setPlayersNumber(3);
    });

    test('When calling setPlayersAstNumber, the players ast number is updated', () {
      final provider = SetupProvider();
      final playersASTNumber = provider.playersAstNumber;
      provider.addListener(() {
        expect(provider.playersAstNumber, 3);
      });

      expect(playersASTNumber, 2);

      provider.setPlayersAstNumber(3);
    });

    test('When calling setMatchesNumber, the matches number is updated', () {
      final provider = SetupProvider();
      final playersNumber = provider.matchesNumber;
      provider.addListener(() {
        expect(provider.matchesNumber, 3);
      });

      expect(playersNumber, 1);

      provider.setMatchesNumber(3);
    });

  });
}
