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
  bool isMounted,
) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext innerContext) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MarginsRaw.borderRadius),
          ),
        ),
        title: provider.activeTournament != null
            ? Text(provider.activeTournament!.name)
            : Container(),
        content: SizedBox(
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
                  style: AppTextStyle.textStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              AppLocalizations.translate(
                context,
                'generic_cancel',
              ),
            ),
            onPressed: () {
              Navigator.of(innerContext).pop();
            },
          ),
          TextButton(
            key: endTournamentKey,
            child: Text(
              AppLocalizations.translate(
                context,
                'generic_ok',
              ),
            ),
            onPressed: () async {
              final tournament = provider.activeTournament;
              EndTournamentResult result = await provider.endTournament();
              if (!isMounted) return;
              if (result == EndTournamentResult.success) {
                // ignore: use_build_context_synchronously
                Navigator.of(innerContext).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => LeaderboardProvider(tournament!),
                        child: const FinalScreen(),
                      ),
                    ),
                    (Route<dynamic> route) => false);
              } else {
                // ignore: use_build_context_synchronously
                Navigator.of(innerContext).pop();
                // ignore: use_build_context_synchronously
                showErrorDialog(innerContext, isMounted);
              }
            },
          )
        ],
      );
    },
  );
}
