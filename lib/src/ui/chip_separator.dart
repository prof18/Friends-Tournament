import 'package:flutter/material.dart';
import 'package:friends_tournament/src/style/app_style.dart';

class ChipSeparator extends StatelessWidget {
  const ChipSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(MarginsRaw.borderRadius),
      ),
      height: 6,
      width: 60,
    );
  }
}
