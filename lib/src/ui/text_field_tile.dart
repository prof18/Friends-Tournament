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

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';
import 'package:friends_tournament/src/style/app_style.dart';
import 'package:friends_tournament/src/ui/text_field_decoration.dart';

class TextFieldTile extends StatefulWidget {
  final TextFieldWrapper textFieldWrapper;

  const TextFieldTile({
    Key key,
    @required this.textFieldWrapper,
  })  : assert(textFieldWrapper != null),
        super(key: key);

  @override
  State<TextFieldTile> createState() {
    return _TextFieldTileState();
  }
}

class _TextFieldTileState extends State<TextFieldTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Margins.small,
      child: Container(
        child: Material(
          elevation: MarginsRaw.elevation,
          borderRadius: BorderRadius.all(
            Radius.circular(MarginsRaw.borderRadius),
          ),
          child: TextField(
            controller: widget.textFieldWrapper.textEditingController,
            decoration: getTextFieldDecoration(widget.textFieldWrapper.label),
          ),
        ),
      ),
    );
  }
}
