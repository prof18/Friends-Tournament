import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/text_field_wrapper.dart';

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
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: TextField(
              controller: widget.textFieldWrapper.textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: widget.textFieldWrapper.label,
              )),
        ),
      ),
    );
  }
}
