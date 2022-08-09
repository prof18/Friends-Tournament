import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friends_tournament/src/data/model/app/end_tournament_result.dart';
import 'package:friends_tournament/src/provider/leaderboard_provider.dart';
import 'package:friends_tournament/src/provider/tournament_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/error_dialog.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/widget_keys.dart';
import 'package:friends_tournament/src/views/tournament/final_screen.dart';
import 'package:provider/provider.dart';

showEndTournamentDialog(
  BuildContext context,
  TournamentProvider provider,
  String? message,
) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext innerContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MarginsRaw.borderRadius),
          ),
        ),
        title: provider.activeTournament != null
            ? Text(provider.activeTournament!.name)
            : Container(),
        content: Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SvgPicture.asset(
                  'assets/finish-art.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: MarginsRaw.regular),
                child: Text(
                  message!,
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child:
                Text(AppLocalizations.translate(context, 'generic_cancel',),),
            onPressed: () {
              Navigator.of(innerContext).pop();
            },
          ),
          FlatButton(
            key: endTournamentKey,
            child: Text(AppLocalizations.translate(context, 'generic_ok',),),
            onPressed: () async {
              final tournament = provider.activeTournament;
              EndTournamentResult result = await provider.endTournament();
              if (result == EndTournamentResult.success) {
                Navigator.of(innerContext).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => LeaderboardProvider(tournament!),
                        child: FinalScreen(),
                      ),
                    ),
                        (Route<dynamic> route) => false);
              } else {
                Navigator.of(innerContext).pop();
                showErrorDialog(innerContext);
              }
            },
          )
        ],
      );
    },
  );
}
