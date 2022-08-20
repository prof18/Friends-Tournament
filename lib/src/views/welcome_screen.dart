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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friends_tournament/src/provider/setup_provider.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/settings/settings_screen.dart';
import 'package:friends_tournament/src/views/setup/setup_pages_container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Padding(
            padding: Margins.regular,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: MarginsRaw.small),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SettingsScreen()),
                            );
                          },
                          child: const Icon(
                            Icons.settings,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: MarginsRaw.medium,
                        right: MarginsRaw.medium,
                      ),
                      child: SvgPicture.asset(
                        'assets/intro-art.svg',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: Margins.regular,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Friends",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Tournament",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: MarginsRaw.regular,
                            ),
                            child: Container(
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius: BorderRadius.circular(
                                    MarginsRaw.borderRadius),
                              ),
                              height: 6,
                              width: 60,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: MarginsRaw.regular,
                            ),
                            child: Text(
                              AppLocalizations.translate(
                                context,
                                'friends_tournament_intro_message',
                              ),
                              style: GoogleFonts.montserrat(
                                textStyle:
                                    Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: MarginsRaw.regular),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ChangeNotifierProvider(
                                          create: (context) => SetupProvider(),
                                          child: const SetupPagesContainer(),
                                        );
                                      },
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          MarginsRaw.borderRadius),
                                      side: BorderSide(color: AppColors.blue)),
                                  padding: Margins.regular,
                                  primary: AppColors.blue,
                                  textStyle: GoogleFonts.montserrat(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .button
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.translate(
                                    context,
                                    'start_tournament_btn',
                                  ),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
