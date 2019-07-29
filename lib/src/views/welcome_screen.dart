import 'package:flutter/material.dart';
import 'package:friends_tournament/src/views/setup/1_number_setup.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("This is the Welcome name page"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.extended(
                elevation: 4.0,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Let's start!"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NumberSetup()),
                  );
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}
