import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/tournament/session_item_widget.dart';

class SessionCarousel extends StatefulWidget {
  final List<UISession> sessions;
  final AnimationController controller;

  SessionCarousel({this.sessions, this.controller});

  @override
  _SessionCarouselState createState() => _SessionCarouselState();
}

class _SessionCarouselState extends State<SessionCarousel> {
  bool _panelExpanded = false;
  TournamentBloc _tournamentBloc;

  @override
  void initState() {
    super.initState();
    widget.controller.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        setState(() {
          _panelExpanded = true;
        });
      } else if (status == AnimationStatus.forward) {
        setState(() {
          _panelExpanded = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _tournamentBloc = TournamentBlocProvider.of(context);

    return Scaffold(
      backgroundColor: hexToColor("#eeeeee"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedOpacity(
        opacity: _panelExpanded ? 0.0 : 1.0,
        duration: Duration(milliseconds: 100),
        child: FloatingActionButton.extended(
          // TODO: localize me
          label: Text("Finish this match"),
          icon: Icon(Icons.save),
          onPressed: () {
            // TODO
            // TODO: show a loader or a popup. Say also that automatically
            // TODO: we skip to the following match
            _tournamentBloc.endMatch().then((_) {
              // TODO: hide the loader and change app state
            });

          },
        ),
      ),
      body: renderBody(context),
    );
  }

  Widget renderBody(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Container(
        decoration: new BoxDecoration(
          color: hexToColor("#eeeeee"),
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.sessions.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: SessionItemWidget(
                          session: widget.sessions[index],
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Container(
                  child: Material(
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 8.0,
                    child: Center(
                      // TODO: implement it!
                      child: Text("First 3 players"),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
