// The equivalent of the "smallestWidth" qualifier on Android.
import 'package:flutter/widgets.dart';

bool isTablet(BuildContext context) {
  final smallestDimension = MediaQuery.of(context).size.shortestSide;
  // Typical breakpoint for a 7-inch tablet.
  return smallestDimension >= 600;
}
