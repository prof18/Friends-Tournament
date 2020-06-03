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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/bloc/providers/setup_bloc_provider.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider.dart';
import 'package:friends_tournament/src/data/database/database_provider_impl.dart';
import 'package:friends_tournament/src/data/database/local_data_source.dart';
import 'package:friends_tournament/src/data/tournament_repository.dart';
import 'package:friends_tournament/src/views/welcome_screen.dart';
import 'package:friends_tournament/style/app_style.dart';

showErrorDialog(BuildContext context) {

  final DatabaseProvider databaseProvider = DatabaseProviderImpl.get;
  final LocalDataSource localDataSource = LocalDataSource(databaseProvider);
  final repository = TournamentRepository(localDataSource);

  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MarginsRaw.borderRadius),
          ),
        ),
        // TODO: localize
        title: Text("Ops 🙁"),
        content: Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SvgPicture.asset(
                  'assets/error-art.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: MarginsRaw.regular),
                child: Text(
                  // TODO: localize
                  "Something is not working! Please apologize me 🙏🏻",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            // TODO: localize
            child: const Text('Restart from scratch'),
            onPressed: () async {
              await repository.finishAllTournament();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => SetupBlocProvider(
                      child: TournamentBlocProvider(
                        child: Welcome(),
                      ),
                    ),
                  ),
                      (Route<dynamic> route) => false);
            },
          )
        ],
      );
    },
  );
}
