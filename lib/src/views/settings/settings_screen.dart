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

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/utils/app_localizations.dart';
import 'package:friends_tournament/src/views/settings/settings_tile.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: MarginsRaw.small,
                  ),
                  child: SizedBox(
                    width: 60,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      'assets/app-icon.png',
                      width: 80,
                    ),
                  ),
                  Padding(
                    padding: Margins.regular,
                    child: Text(
                      "Friends Tournament",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: MarginsRaw.regular,
                      right: MarginsRaw.regular,
                    ),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('friends_tournament_claim'),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: MarginsRaw.medium,
                  ),
                  GestureDetector(
                    onTap: () {
                      _openURL("https://github.com/prof18/Friends-Tournament/");
                    },
                    child: SettingsTile(
                      AppLocalizations.of(context).translate('show_github'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _openURL(
                          "https://github.com/prof18/Friends-Tournament/blob/master/privacy_policy.md");
                    },
                    child: SettingsTile(
                      AppLocalizations.of(context).translate('privacy_policy'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      LicenseRegistry.addLicense(() async* {
                        yield LicenseEntryWithLineBreaks(
                            <String>['freepik'], '''
                              <a href="https://it.freepik.com/foto-vettori-gratuito/design">Vectors and illustrations from freepik - freepik.com</a>''');
                      });

                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => Theme(
                          data: Theme.of(context).copyWith(
                              textTheme: Typography.material2018(
                                platform: Theme.of(context).platform,
                              ).black,
                              scaffoldBackgroundColor: Colors.white,
                              appBarTheme: AppBarTheme(
                                brightness: Brightness.light,
                              )),
                          child: LicensePage(
                            applicationName: "Friends Tournament",
                            applicationLegalese: "© 2019-2020 Marco Gomiero",
                          ),
                        ),
                      ));
                    },
                    child: SettingsTile(
                      AppLocalizations.of(context)
                          .translate('open_source_license'),
                    ),
                  ),
                  SizedBox(
                    height: MarginsRaw.medium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: MarginsRaw.small,
                      left: MarginsRaw.regular,
                      right: MarginsRaw.regular,
                    ),
                    child: FutureBuilder<String>(
                      future: getAppVersion(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.hasData
                              ? "${AppLocalizations.of(context).translate('app_version')}: ${snapshot.data}"
                              : "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: MarginsRaw.regular, bottom: MarginsRaw.small),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black38, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                            text: AppLocalizations.of(context)
                                .translate('developed_by'),
                          ),
                          TextSpan(
                              style: TextStyle(color: AppColors.blue),
                              text: 'Marco Gomiero',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _openURL("https://www.marcogomiero.com");
                                }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
