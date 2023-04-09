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
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/utils/is_tablet.dart';
import 'package:google_fonts/google_fonts.dart';

class Margins {
  static const small = EdgeInsets.all(8.0);
  static const regular = EdgeInsets.all(16.0);
  static const medium = EdgeInsets.all(24.0);

  static EdgeInsets getRegular(BuildContext context) {
    if (isTablet(context)) {
      return const EdgeInsets.all(32.0);
    } else {
      return const EdgeInsets.all(0.0);
    }
  }

}

class MarginsRaw {
  static const small = 8.0;
  static const regular = 16.0;
  static const medium = 24.0;
  static const large = 48.0;
  static const xlarge = 56.0;
  static const xxlarge = 60.0;

  static const borderRadius = 18.0;

  static const elevation = 6.0;
}

class AppColors {
  static final blue = hexToColor("#1838F9");
}

class AppTextStyle {
  static final onboardingTitleStyle = GoogleFonts.montserrat(
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );

  static TextStyle textStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return GoogleFonts.montserrat(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
