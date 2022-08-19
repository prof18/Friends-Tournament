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
import 'package:friends_tournament/src/style/app_style.dart';

class SettingsTile extends StatelessWidget {
  final String? title;

  const SettingsTile(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: MarginsRaw.small, bottom: MarginsRaw.small,),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(
          6,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - (MarginsRaw.regular * 4),
          child: Padding(
            padding: Margins.regular,
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
