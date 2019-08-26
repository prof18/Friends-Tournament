import 'dart:math';

import 'package:flutter/material.dart';
import 'package:friends_tournament/src/ui/page_transformer.dart';
import 'package:friends_tournament/src/views/tournament/session_item_widget.dart';

class Carousel extends StatefulWidget {
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  // TODO: get it from the db
  static List<String> sessions = ["Session 1", "Session 2", "Session 3"];
  var currentPage = sessions.length - 1.0;

  @override
  Widget build(BuildContext context) {
    child:
    return Column(
      children: <Widget>[
        Expanded(child: renderBody()),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: renderBottomBar(),
        )
      ],
    );
  }

  Widget renderBody() {
    PageController controller =
        PageController(initialPage: sessions.length - 1);
    controller.addListener(
      () {
        setState(
          () {
            currentPage = controller.page;
          },
        );
      },
    );

    return Container(
      child: PageTransformer(
        pageViewBuilder: (context, visibilityResolver) {
          return PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final item = sessions[index];
              final pageVisibility =
                  visibilityResolver.resolvePageVisibility(index);
              return SessionItemWidget(
                item: item,
                pageVisibility: pageVisibility,
              );
            },
          );
        },
      ),
    );
  }

  Widget renderBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            // TODO: localize me
            label: Text("End this match"),
            onPressed: () {
              // TODO
            },
          ),
        )
      ],
    );
  }
}
