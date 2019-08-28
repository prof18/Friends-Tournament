/// Adapted from https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/shrine/shopping_cart.dart

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/ui/expanding_bottom_sheet.dart';

const double _leftColumnWidth = 60.0;

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.pink,
      body: SafeArea(
        child: Container(
            child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: _leftColumnWidth,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onPressed: () =>
                            ExpandingBottomSheet.of(context).close(),
                      ),
                    ),
                    Text(
                      'Leaderboard',
                      style: localTheme.textTheme.subhead
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Container(
                  color: Colors.pink,
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
