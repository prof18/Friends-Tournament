import 'package:flutter/material.dart';
import 'package:friends_tournament/src/ui/page.dart';
import 'package:friends_tournament/src/views/setup/matches_name.dart';
import 'package:friends_tournament/src/views/setup/number_setup_screen.dart';
import 'package:friends_tournament/src/views/setup/users_name_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  bool isFirstPage() {
    return this._currentPage == 0;
  }

  bool isFinalPage() {
    return this._currentPage == _allPages.length - 1;
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
          Padding(padding: const EdgeInsets.all(16.0), child: createBottomBar())
        ],
      ),
    ));
  }

  Widget createBottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Opacity(
            opacity: _currentPage == 0 ? 0 : 1,
            child: InkResponse(
              child: SvgPicture.asset(
                'assets/left_arrow.svg',
              ),
              onTap: this.isFirstPage()
                  ? null
                  : () {
                      setState(() {
                        _controller.animateTo(this._currentPage - 1);
                      });
                    },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: FloatingActionButton(
            child: this.isFinalPage()
                ? Icon(
                    Icons.done,
                  )
                : Text(
                    (this._currentPage + 1).toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
            onPressed: this.isFinalPage()
                ? () {
                    // TODO: implement
                  }
                : null,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Opacity(
            opacity: this.isFinalPage() ? 0 : 1,
            child: InkResponse(
              enableFeedback: _currentPage == 2 ? false : true,
              child: SvgPicture.asset(
                'assets/right_arrow.svg',
              ),
              onTap: this.isFinalPage()
                  ? null
                  : () {
                      _controller.animateTo(this._currentPage + 1);
                    },
            ),
          ),
        ),
      ],
    );
  }
}
