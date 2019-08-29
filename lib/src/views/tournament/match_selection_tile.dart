import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/ui/utils.dart';

class MatchSelectionTile extends StatefulWidget {

  final UIMatch match;

  MatchSelectionTile({this.match});

  @override
  _MatchSelectionTileState createState() => _MatchSelectionTileState();
}

class _MatchSelectionTileState extends State<MatchSelectionTile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.match.name,
      style: TextStyle(
        fontSize: 24
      ),),
    );
  }
}
