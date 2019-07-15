import 'package:flutter/material.dart';
import 'package:friends_tournament/src/ui/page.dart';
import 'package:friends_tournament/src/views/setup/matches_name.dart';
import 'package:friends_tournament/src/views/setup/number_setup_screen.dart';
import 'package:friends_tournament/src/views/setup/users_name_screen.dart';

class Setup extends StatefulWidget {
  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> with SingleTickerProviderStateMixin {
  TabController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
    _controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Page> _allPages = [
    Page(widget: NumberSetup()),
    Page(widget: UserName()),
    Page(widget: MatchesName())
  ];

  void _onTabChanged() {
    setState(() {
      _currentPage = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: _allPages.map<Widget>((Page page) {
                  return Container(
                    child: Container(
                        key: ObjectKey(page.widget),
                        padding: const EdgeInsets.all(12.0),
                        child: page.widget),
                  );
                }).toList()),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () {
                    // TODO: improve and disable the tap
                    if (this._currentPage != 0) {
                      setState(() {
                        _controller.animateTo(this._currentPage - 1);
                      });
                    }
                  },
                ),
                Text(this._currentPage.toString()),
                InkWell(
                  child: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: improve and disable the tap
                    if (this._currentPage != _allPages.length - 1) {
                      _controller.animateTo(this._currentPage + 1);
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
