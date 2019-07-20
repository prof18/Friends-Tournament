import 'package:flutter/material.dart';

class MatchSetup extends StatefulWidget {
  @override
  _MatchSetupState createState() => _MatchSetupState();
}

class _MatchSetupState extends State<MatchSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.yellow,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: createBottomBar(),
            )
          ],
        ),
      ),
    );
  }

  Widget createBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "btn1",
          child: Icon(
              Icons.arrow_back_ios
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FloatingActionButton(
          heroTag: "btn2",
          child: Icon(
              Icons.done
          ),
          onPressed: () {

          },
        )
      ],
    );
  }
}