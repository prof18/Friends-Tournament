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
import 'package:flutter/widgets.dart';
import 'package:friends_tournament/style/app_style.dart';

class SetupCounterWidget extends StatelessWidget {
  final Sink<int> inputStream;
  final Stream<int> outputStream;
  final int minValue;
  final int maxValue;

  SetupCounterWidget({
    @required this.inputStream,
    @required this.outputStream,
    this.minValue = 0,
    this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: minValue,
      builder: (context, snapshot) {
        return Material(
          elevation: 6,
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
                      snapshot.data.toString(),
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: MarginsRaw.small),
                  child: Row(
                    children: [
                      Visibility(
                        visible: snapshot.data == minValue ? false : true,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: MarginsRaw.small),
                          child: GestureDetector(
                            onTap: () => inputStream.add(snapshot.data - 1),
                            child: Icon(
                              Icons.remove,
                              size: 36,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: maxValue != null ? snapshot.data < maxValue : true,
                        child: Padding(
                          padding: const EdgeInsets.only(left: MarginsRaw.small),
                          child: GestureDetector(
                            onTap: () => inputStream.add(snapshot.data + 1),
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
      },
      stream: outputStream,
    );
  }
}
