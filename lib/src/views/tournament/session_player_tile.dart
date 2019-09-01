import 'package:flutter/material.dart';

class SessionPlayerTile extends StatefulWidget {
  // TODO: pass an object, not the simple string
  final String playerName;
  final int score;
  final int step;

  final double buttonSize = 20;
  final double iconSize = 16;

  SessionPlayerTile({this.playerName, this.score, this.step = 1});

  @override
  _SessionPlayerTileState createState() => _SessionPlayerTileState();
}

class _SessionPlayerTileState extends State<SessionPlayerTile> {
  // TODO: not hold here, but in bloc
  int _score;
  int _step;

  @override
  void initState() {
    super.initState();
    setState(() {
      this._score = widget.score;
      this._step = widget.step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.playerName,
            style: TextStyle(fontSize: 22),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: widget.buttonSize,
                height: widget.buttonSize,
                child: FloatingActionButton(
                  onPressed: _decrementScore,
                  elevation: 2,
                  child: Icon(
                    Icons.remove,
                    size: widget.iconSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _score.toString(),
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                width: widget.buttonSize,
                height: widget.buttonSize,
                child: FloatingActionButton(
                  onPressed: _incrementScore,
                  elevation: 2,
                  child: Icon(
                    Icons.add,
                    size: widget.iconSize,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _incrementScore() {
    setState(() {
      _score += _step;
    });
  }

  _decrementScore() {
    if (_score - _step >= 0) {
      setState(() {
        _score -= _step;
      });
    }
  }
}
