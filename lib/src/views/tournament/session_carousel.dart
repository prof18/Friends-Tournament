import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/tournament/session_item_widget.dart';

class Carousel extends StatelessWidget {
  final List<UISession> sessions;

  Carousel({this.sessions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#eeeeee"),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        // TODO: localize me
        label: Text("End this match"),
        onPressed: () {
          // TODO
        },
      ),
      body: renderBody(context),
    );
  }

  Widget renderBody(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: SessionItemWidget(
                session: sessions[index],
              ),
            );
          }),
    );
  }
}
