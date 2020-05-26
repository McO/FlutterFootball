import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/team/team_head.dart';
import 'package:FlutterFootball/widgets/team/team_news.dart';
import 'package:FlutterFootball/widgets/team/team_season.dart';
import 'package:FlutterFootball/widgets/team/team_squad.dart';
import '../models/models.dart';

class TeamDetail extends StatefulWidget {
  final Team team;

  TeamDetail(this.team);

  @override
  _TeamDetailState createState() => _TeamDetailState(team);
}

class _TeamDetailState extends State<TeamDetail> with SingleTickerProviderStateMixin {
  final Team team;
  List<Widget> tabs;

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
    tabs = [
      Tab(child: Text("News", style: Theme.of(context).textTheme.headline3)),
      Tab(child: Text("Season", style: Theme.of(context).textTheme.headline3)),
      Tab(child: Text("Squad", style: Theme.of(context).textTheme.headline3)),
    ];

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 120.0,
                floating: true,
                pinned: true,
//                backgroundColor: Colors.amberAccent,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
//                    titlePadding:  EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    title: Text(
                      team.name,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                    background: TeamHead(team)),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.white,
                      controller: _tabController,
                    tabs: tabs),
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
