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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friends_tournament/src/views/setup/1_tournament_name.dart';
import 'package:friends_tournament/src/views/setup/number_setup.dart';
import 'package:friends_tournament/src/views/setup/setup_container.dart';
import 'package:friends_tournament/style/app_style.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

// TODO: extract all design stuff into something
class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Margins.regular,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: MarginsRaw.medium,
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
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              "Tournament",
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
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
                            borderRadius:
                                BorderRadius.circular(MarginsRaw.borderRadius),
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
                          "Start a new tournament with your friends",
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: MarginsRaw.regular),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MarginsRaw.borderRadius),
                              side: BorderSide(color: AppColors.blue)),
                          color: AppColors.blue,
                          textColor: Colors.white,
                          padding: Margins.regular,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetupContainer()),
                            );
                          },
                          child: Text(
                            'Start Tournament',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
