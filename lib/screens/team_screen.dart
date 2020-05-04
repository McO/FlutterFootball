import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/team_head.dart';
import 'package:FlutterFootball/widgets/team_news.dart';
import 'package:FlutterFootball/widgets/team_season.dart';
import 'package:FlutterFootball/widgets/team_squad.dart';
import '../models/models.dart';

class TeamDetail extends StatefulWidget {
  final Team team;

  TeamDetail(this.team);

  @override
  _TeamDetailState createState() => _TeamDetailState(team);
}

class _TeamDetailState extends State<TeamDetail> with SingleTickerProviderStateMixin {
  final Team team;

  _TeamDetailState(this.team);

  TabController _tabController;

  @override
  void initState() {

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(background: TeamHead(team)),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(child: Text("News", style: Theme.of(context).textTheme.display2)),
                      Tab(child: Text("Season", style: Theme.of(context).textTheme.display2)),
                      Tab(child: Text("Squad", style: Theme.of(context).textTheme.display2)),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              TeamNews(team),
              TeamSeason(team),
              TeamSquad(team),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
