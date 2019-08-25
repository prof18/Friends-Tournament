import 'package:flutter/material.dart';
import 'package:friends_tournament/src/ui/page_transformer.dart';
import 'package:friends_tournament/src/ui/utils.dart';

class SessionItemWidget extends StatelessWidget {
  SessionItemWidget({
    @required this.item,
    @required this.pageVisibility,
  });

  // TODO: replace with correct item
  final String item;
  final PageVisibility pageVisibility;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 22.0,
        horizontal: 8.0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          color: hexToColor("#C4C4C4"),
          child: Container(
            child: Center(
                child: Text(
                  "blabla",
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ),
      ),
    );
  }
}
