import 'package:flutter/foundation.dart';
import 'package:friends_tournament/src/data/model/app/first_screen_type.dart';
import 'package:friends_tournament/src/data/model/db/tournament.dart';
import 'package:friends_tournament/src/utils/service_locator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainProvider with ChangeNotifier {

  MainProvider() {
   _computeData();
  }

  FirstScreenType _firstScreenType = FirstScreenType.loading();
  FirstScreenType get firstScreenType => _firstScreenType;

  _computeData() async {
    var isTournamentActive = false;
    Tournament? lastTournament;
    try {
      isTournamentActive = await tournamentRepository.isTournamentActive();
      if (!isTournamentActive) {
        lastTournament = await tournamentRepository.getLastFinishedTournament();
      }
    } on Exception catch (_) {
      // do nothing, we assume that the tournament is not active
    }

    await _precacheSVG();

    if (isTournamentActive) {
      _firstScreenType = FirstScreenType.tournament();
    } else if (lastTournament != null) {
      _firstScreenType = FirstScreenType.lastTournamentResult(lastTournament);
    } else {
      _firstScreenType = FirstScreenType.welcome();
    }

    notifyListeners();
  }

  _precacheSVG() async {
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/intro-art.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/players_art.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/player-ast-art.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/matches-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/podium-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/error-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/finish-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/save-art.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, 'assets/winner-art.svg'),
        null);
  }
}