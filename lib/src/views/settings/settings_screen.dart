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
  const SettingsScreen({Key? key}) : super(key: key);

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static void _openURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
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
                    left: MarginsRaw.regular,
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
                  _buildAppIcon(),
                  _buildAppTitle(),
                  _buildAppDescription(context),
                  const SizedBox(
                    height: MarginsRaw.medium,
                  ),
                  _buildGithubTile(context),
                  _buildPrivacyPolicyTile(context),
                  _buildLicensesTile(
                    context,
                    () => {_navigateToLicenseScreen(context)},
                  ),
                  const SizedBox(
                    height: MarginsRaw.medium,
                  ),
                  _buildAppVersionLabel(),
                  _buildAuthorLabel(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Image.asset(
        'assets/app-icon.png',
        width: 80,
      ),
    );
  }

  Padding _buildAppTitle() {
    return Padding(
      padding: Margins.regular,
      child: Text(
        "Friends Tournament",
        textAlign: TextAlign.center,
        style: AppTextStyle.textStyle(fontSize: 32),
      ),
    );
  }

  Widget _buildAppDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: MarginsRaw.regular,
        right: MarginsRaw.regular,
      ),
      child: Text(
        AppLocalizations.translate(context, 'friends_tournament_claim'),
        textAlign: TextAlign.center,
        style: AppTextStyle.textStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildGithubTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openURL("https://github.com/prof18/Friends-Tournament/");
      },
      child: SettingsTile(
        AppLocalizations.translate(context, 'show_github'),
      ),
    );
  }

  Widget _buildPrivacyPolicyTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openURL(
          "https://www.prof18.com/friends-tournament/pp/privacy-policy-aug22/",
        );
      },
      child: SettingsTile(
        AppLocalizations.translate(context, 'privacy_policy'),
      ),
    );
  }

  Widget _buildLicensesTile(BuildContext context, Function() onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: SettingsTile(
        AppLocalizations.translate(
          context,
          'open_source_license',
        ),
      ),
    );
  }

  Future<void> _navigateToLicenseScreen(BuildContext context) async {
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString(
        'google_fonts/OFL.txt',
      );
      yield LicenseEntryWithLineBreaks(
        ['google_fonts'],
        license,
      );
      yield const LicenseEntryWithLineBreaks(
        <String>['freepik'],
        '''<a href="https://it.freepik.com/foto-vettori-gratuito/design">Vectors and illustrations from freepik - freepik.com</a>''',
      );
    });

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Theme(
          data: Theme.of(context),
          child: const LicensePage(
            applicationName: "Friends Tournament",
            applicationLegalese: "© 2019-2020 Marco Gomiero",
          ),
        ),
      ),
    );
  }

  Widget _buildAppVersionLabel() {
    return Padding(
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
                ? "${AppLocalizations.translate(context, 'app_version')}: ${snapshot.data}"
                : "",
            textAlign: TextAlign.center,
            style: AppTextStyle.textStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuthorLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: MarginsRaw.regular,
        bottom: MarginsRaw.small,
      ),
      child: RichText(
        text: TextSpan(
          style: AppTextStyle.textStyle(
            fontSize: 16,
            color: Colors.black38,
          ),
          children: <TextSpan>[
            TextSpan(
              text: AppLocalizations.translate(
                context,
                'developed_by',
              ),
            ),
            TextSpan(
              style: AppTextStyle.textStyle(
                fontSize: 16,
                color: AppColors.blue,
              ),
              text: 'Marco Gomiero',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _openURL("https://www.marcogomiero.com");
                },
            ),
          ],
        ),
      ),
    );
  }
}
