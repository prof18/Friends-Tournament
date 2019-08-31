import 'package:flutter/material.dart';
import 'package:friends_tournament/src/data/model/app/ui_session.dart';
import 'package:friends_tournament/src/ui/page_transformer.dart';
import 'package:friends_tournament/src/ui/utils.dart';
import 'package:friends_tournament/src/views/tournament/session_item_widget.dart';

class Carousel extends StatefulWidget {
  final List<UISession> sessions;

  Carousel({this.sessions});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  double currentPage;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPage = widget.sessions.length - 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: hexToColor("#EEEEEE"),
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
  }

  Widget renderBody() {
    PageController controller =
        PageController(initialPage: widget.sessions.length - 1);
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
            itemCount: widget.sessions.length,
            itemBuilder: (context, index) {
              final item = widget.sessions[index];
              final pageVisibility =
                  visibilityResolver.resolvePageVisibility(index);
              return SessionItemWidget(
                session: item,
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
