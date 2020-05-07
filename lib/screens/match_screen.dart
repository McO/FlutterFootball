import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/match_head.dart';
import 'package:FlutterFootball/widgets/match_lineup.dart';
import 'package:FlutterFootball/widgets/match_liveticker.dart';
import 'package:FlutterFootball/widgets/match_overview.dart';
import 'package:FlutterFootball/widgets/match_stats.dart';
import '../models/match.dart';

class MatchDetail extends StatefulWidget {
  final Match match;

  MatchDetail(this.match);

  @override
  _MatchDetailState createState() => _MatchDetailState(match);
}

class _MatchDetailState extends State<MatchDetail>
    with SingleTickerProviderStateMixin {
  final Match match;
  ScrollController _scrollController;
  TabController _tabController;
  bool silverCollapsed = false;
  String myTitle = "";

  _MatchDetailState(this.match);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
    _tabController.addListener(() {
      setState(() {});
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      print(_scrollController.offset);
      if (_scrollController.offset > 100 &&
          !_scrollController.position.outOfRange) {
        if (!silverCollapsed) {
          // do what ever you want when silver is collapsing !

          print(_scrollController.offset);
          myTitle = '${match.homeTeam.shortName} - ${match.awayTeam.shortName}';
          silverCollapsed = true;
          setState(() {});
        }
      }
      if (_scrollController.offset <= 100 &&
          !_scrollController.position.outOfRange) {
        if (silverCollapsed) {
          // do what ever you want when silver is expanding !

          myTitle = "";
          silverCollapsed = false;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 140.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(myTitle),
                    // title: MatchHead(match), //Text(myTitle),
                    collapseMode: CollapseMode.parallax,
                    background: MatchHead(match)),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(
                          child: Text("Overview",
                              style: Theme.of(context).textTheme.display2)),
                      Tab(
                          child: Text("Live Ticker",
                              style: Theme.of(context).textTheme.display2)),
                      Tab(
                          child: Text("Line-up",
                              style: Theme.of(context).textTheme.display2)),
                      Tab(
                          child: Text("Stats",
                              style: Theme.of(context).textTheme.display2)),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              MatchOverview(match),
              MatchLiveTicker(match),
              MatchLineUp(match),
              MatchStats(match),
            ],
            controller: _tabController,
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Theme.of(context).primaryColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
