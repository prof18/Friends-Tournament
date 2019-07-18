import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';

class NumberSetup extends StatefulWidget {
  @override
  _NumberSetupState createState() => _NumberSetupState();
}

class _NumberSetupState extends State<NumberSetup> {
  TextEditingController _tournamentController = new TextEditingController();
  TextEditingController _playersController = new TextEditingController();
  TextEditingController _playersAstController = new TextEditingController();
  TextEditingController _matchesController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var setupBloc = SetupBlocProvider.of(context);

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                "New Tournament",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32),
              ),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                      child: TextField(
                          controller: _tournamentController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Tournament Name',
                          )),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SvgPicture.asset(
                            'assets/players_icon.svg',
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              onSubmitted: (value) {
                                print("Value: $value");
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Number of players',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SvgPicture.asset(
                            'assets/players_ast_icon.svg',
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _playersAstController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Number of players at the same time',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SvgPicture.asset(
                            'assets/matches_icon.svg',
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _matchesController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Number of matches',
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
