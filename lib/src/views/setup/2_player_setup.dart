import 'package:flutter/material.dart';
import 'package:friends_tournament/src/ui/slide_left_route.dart';
import 'package:friends_tournament/src/views/setup/3_match_setup.dart';

class PlayerSetup extends StatefulWidget {
  @override
  _PlayerSetupState createState() => _PlayerSetupState();
}

class _PlayerSetupState extends State<PlayerSetup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.green,
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
              Icons.arrow_forward_ios
          ),
          onPressed: () {
            Navigator.push(
              context,
              SlideLeftRoute(page: MatchSetup()),
            );
          },
        )
      ],
    );
  }
}