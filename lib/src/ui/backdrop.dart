import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Backdrop extends StatefulWidget {
  final Widget dropdownWidget;
  final Widget contentWidget;

  @override
  _BackdropState createState() => _BackdropState();

  Backdrop(this.dropdownWidget, this.contentWidget);

}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const _PANEL_HEADER_HEIGHT = 32.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 100), value: 1.0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool get _isPanelVisible {
    var status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final top = height - _PANEL_HEADER_HEIGHT;
    final bottom = -_PANEL_HEADER_HEIGHT;
    return RelativeRectTween(
            begin: RelativeRect.fromLTRB(0.0, top, 0.0, bottom),
            end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue.shade500,
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        // TODO: take the title from a bloc stream
        title: Text("Match 1"),
        leading: IconButton(
            onPressed: () {
              _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: _controller.view,
            )),
      ),
      body: LayoutBuilder(
        builder: _buildStack,
      ),
    );
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    final animation = _getPanelAnimation(constraints);
    final theme = Theme.of(context);
    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          widget.dropdownWidget,
          new PositionedTransition(
            rect: animation,
            child: new Material(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              elevation: 12.0,
              child: widget.contentWidget
            ),
          )
        ],
      ),
    );
  }
}
