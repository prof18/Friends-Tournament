import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/ui/slide_left_route.dart';
import 'package:friends_tournament/src/views/setup/2_player_setup.dart';

class NumberSetup extends StatefulWidget {
  @override
  _NumberSetupState createState() => _NumberSetupState();
}

class _NumberSetupState extends State<NumberSetup> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _tournamentController = new TextEditingController();
  TextEditingController _playersController = new TextEditingController();
  TextEditingController _playersAstController = new TextEditingController();
  TextEditingController _matchesController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: StreamBuilder<Object>(
          stream: null,
          builder: (context, snapshot) {
            return SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(child: renderBody()),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: renderBottomBar(),
                  )
                ],
              ),
            );
          }),
    );
  }

  void goToNextPage() {
    var setupBloc = SetupBlocProvider.of(context);

    if (_tournamentController.text.isEmpty ||
        _playersController.text.isEmpty ||
        _playersAstController.text.isEmpty ||
        _matchesController.text.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Complete all the field')));
      return;
    }

    setupBloc.setTournamentName.add(_tournamentController.text);
    setupBloc.setPlayersNumber.add(int.parse(_playersController.text));
    setupBloc.setPlayersAstNumber.add(int.parse(_playersAstController.text));
    setupBloc.setMatchesNumber.add(int.parse(_matchesController.text));

    Navigator.push(
      context,
      SlideLeftRoute(page: PlayerSetup()),
    );
  }

  Widget renderBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FloatingActionButton(
          heroTag: "btn2",
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            goToNextPage();
          },
        )
      ],
    );
  }

  Widget renderBody() {
    return Container(
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
                    padding: const EdgeInsets.all(20),
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
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SvgPicture.asset(
                          'assets/players_icon.svg',
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextField(
                            controller: _playersController,
                            keyboardType: TextInputType.number,
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
                        padding: const EdgeInsets.only(left: 20.0),
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
                        padding: const EdgeInsets.only(left: 20.0),
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
    );
  }
}
