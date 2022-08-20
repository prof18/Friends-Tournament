import 'package:flutter/material.dart';
import 'package:friends_tournament/src/style/app_style.dart';

class SetupChipSeparator extends StatelessWidget {
  const SetupChipSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: MarginsRaw.medium,
        bottom: MarginsRaw.medium,
      ),
      child: Container(
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(MarginsRaw.borderRadius),
        ),
        height: 6,
        width: 60,
      ),
    );
  }
}
