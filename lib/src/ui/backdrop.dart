/*
 * Copyright 2019 Marco Gomiero
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friends_tournament/src/bloc/tournament_bloc.dart';
import 'package:friends_tournament/src/bloc/providers/tournament_bloc_provider.dart';
import 'package:friends_tournament/src/data/model/app/ui_match.dart';
import 'package:friends_tournament/src/ui/custom_icons_icons.dart';
import 'package:friends_tournament/style/app_style.dart';

class Backdrop extends StatefulWidget {
  final Widget dropdownWidget;
  final Widget contentWidget;
  final AnimationController controller;

  @override
  _BackdropState createState() => _BackdropState();

  Backdrop(this.dropdownWidget, this.contentWidget, this.controller);
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const _PANEL_HEADER_HEIGHT = 32.0;

  bool _panelExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;

    _controller.addStatusListener((status) {
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
      statusBarColor: AppColors.blue,
    ));

    TournamentBloc tournamentBloc = TournamentBlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0.0,
        title: AnimatedOpacity(
          opacity: _panelExpanded ? 0.0 : 1.0,
          duration: Duration(milliseconds: 200),
          child: StreamBuilder<UIMatch>(
            stream: tournamentBloc.currentMatch,
            builder: (context, snapshot) {
              return snapshot.hasData ? Text(snapshot.data.name) : Text("");
            },
          ),
        ),
        leading: IconButton(
          onPressed: () {
            _controller.fling(velocity: _isPanelVisible ? -1.0 : 1.0);
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _controller.view,
          ),
        ),
        actions: <Widget>[
          Visibility(
            visible: !_panelExpanded,
            child: IconButton(
              icon: Icon(CustomIcons.flag_checkered),
              onPressed: () {
                // TODO
              },
              // TODO: localize me
              tooltip: "Finish the tournament",
            ),
          ),
        ],
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
      color: AppColors.blue,
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
                child: widget.contentWidget),
          )
        ],
      ),
    );
  }
}
