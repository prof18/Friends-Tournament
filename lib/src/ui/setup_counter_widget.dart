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
import 'package:friends_tournament/src/utils/widget_keys.dart';

class SetupCounterWidget extends StatelessWidget {
  final int minValue;
  final int? maxValue;
  final int? currentValue;
  final Function(int value)? onIncrease;
  final Function(int value)? onDecrease;

  SetupCounterWidget({
    this.minValue = 0,
    this.maxValue,
    this.currentValue,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: MarginsRaw.elevation,
      borderRadius: BorderRadius.all(
        Radius.circular(MarginsRaw.borderRadius),
      ),
      child: Padding(
        padding: Margins.small,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: MarginsRaw.small),
              child: Padding(
                padding: Margins.regular,
                child: Text(
                  currentValue.toString(),
                  style: TextStyle(fontSize: 28),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: MarginsRaw.small),
              child: Row(
                children: [
                  Visibility(
                    visible: currentValue == minValue ? false : true,
                    child: Padding(
                      padding: const EdgeInsets.only(right: MarginsRaw.small),
                      child: GestureDetector(
                        key: counterWidgetMinusButton,
                        onTap: () => onDecrease!(currentValue! - 1),
                        child: Icon(
                          Icons.remove,
                          size: 36,
                          color: Colors.black38,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: maxValue != null ? currentValue! < maxValue! : true,
                    child: Padding(
                      padding: const EdgeInsets.only(left: MarginsRaw.small),
                      child: GestureDetector(
                        key: counterWidgetPlusButton,
                        onTap: () => onIncrease!(currentValue! + 1),
                        child: Icon(
                          Icons.add,
                          size: 36,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
