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

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/utils/service_locator.dart';
import 'package:friends_tournament/src/views/welcome_screen.dart';

showErrorDialog(BuildContext context, bool isMounted) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(MarginsRaw.borderRadius),
          ),
        ),
        title: Text(
          AppLocalizations.translate(
            context,
            'something_not_working_title',
          ),
        ),
        content: SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/error-art.svg',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: MarginsRaw.regular),
                child: Text(
                  AppLocalizations.translate(
                    context,
                    'something_not_working_message',
                  ),
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
                'restart_from_scratch',
              ),
            ),
            onPressed: () async {
              await tournamentRepository.finishAllTournament();
              if (!isMounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Welcome()),
                (Route<dynamic> route) => false,
              );
            },
          )
        ],
      );
    },
  );
}
