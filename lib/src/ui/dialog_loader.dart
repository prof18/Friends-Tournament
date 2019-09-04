import 'package:flutter/material.dart';

/// A dialog loader with a nice open and close animation.
/// In order to control it, you need to create the animation controller outside.
/// For example:
///
/// AnimationController(vsync: this, duration: Duration(milliseconds: 450));
///
/// N.B. remember to use the mixin on the State:
///
///   with SingleTickerProviderStateMixin
///
/// To start the dialog:
///
///    showDialog(
///     context: context,
///     barrierDismissible: false,
///     builder: (_) => DialogLoader(
///       controller: _controller,
///       text: "This is loading something",
///     )
///   );
///
/// To close it, call the reverse animation and then pop the navigation
///
///   _controller.reverse().then((_) {
///     Navigator.pop(context);
///   });
///
class DialogLoader extends StatefulWidget {
  final String text;
  final AnimationController controller;

  DialogLoader({this.text, @required this.controller});

  @override
  State<StatefulWidget> createState() => DialogLoaderState();
}

class DialogLoaderState extends State<DialogLoader>
    with SingleTickerProviderStateMixin {
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    scaleAnimation =
        CurvedAnimation(parent: widget.controller, curve: Curves.elasticInOut);
    widget.controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: Text(widget.text),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
