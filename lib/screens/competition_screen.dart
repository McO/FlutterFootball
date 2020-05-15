import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/competition_head.dart';
import 'package:FlutterFootball/widgets/competition_overview.dart';
import 'package:FlutterFootball/models/models.dart';

class CompetitionDetail extends StatefulWidget {
  final Competition competition;

  CompetitionDetail(this.competition);

  @override
  _CompetitionDetailState createState() => _CompetitionDetailState(competition);
}

class _CompetitionDetailState extends State<CompetitionDetail>
    with SingleTickerProviderStateMixin {
  final Competition competition;
  ScrollController _scrollController;
  TabController _tabController;
  bool silverCollapsed = false;
  String myTitle = "";

  _CompetitionDetailState(this.competition);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController.addListener(() {
      setState(() {});
    });

    // _scrollController = ScrollController();
    // _scrollController.addListener(() {
    //   print(_scrollController.offset);
    //   if (_scrollController.offset > 100 &&
    //       !_scrollController.position.outOfRange) {
    //     if (!silverCollapsed) {
    //       // do what ever you want when silver is collapsing !

    //       print(_scrollController.offset);
    //       // myTitle = '${match.homeTeam.shortName} - ${match.awayTeam.shortName}';
    //       silverCollapsed = true;
    //       setState(() {});
    //     }
    //   }
    //   if (_scrollController.offset <= 100 &&
    //       !_scrollController.position.outOfRange) {
    //     if (silverCollapsed) {
    //       // do what ever you want when silver is expanding !

    //       myTitle = "";
    //       silverCollapsed = false;
    //       setState(() {});
    //     }
    //   }
    // });
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
                expandedHeight: 110.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(myTitle),
                    // title: MatchHead(match), //Text(myTitle),
                    collapseMode: CollapseMode.parallax,
                    background: CompetitionHead(competition)),
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
                              style: Theme.of(context).textTheme.headline3)),
                      Tab(
                          child: Text("Standings",
                              style: Theme.of(context).textTheme.headline3)),
                      Tab(
                          child: Text("News",
                              style: Theme.of(context).textTheme.headline3)),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              CompetitionOverview(competition),
              CompetitionOverview(competition),
              CompetitionOverview(competition),
              // MatchLiveTicker(match),
              // MatchLineUp(match),
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
