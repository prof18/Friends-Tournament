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

InputDecoration getTextFieldDecoration(String? hintText) {
  return InputDecoration(
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(MarginsRaw.borderRadius),
        ),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(MarginsRaw.borderRadius),
        ),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(MarginsRaw.borderRadius),
        ),
        borderSide: BorderSide(color: Colors.transparent),
      ),
      filled: true,
      hintStyle: TextStyle(
        color: Colors.grey[500],
      ),
      hintText: hintText,
      fillColor: Colors.white70);
}
