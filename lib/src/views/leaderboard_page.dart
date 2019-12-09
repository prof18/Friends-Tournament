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
