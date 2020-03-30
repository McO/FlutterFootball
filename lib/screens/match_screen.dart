import 'package:FlutterFootball/widgets/match_head.dart';
import 'package:flutter/material.dart';
import '../models/match.dart';

class MatchDetail extends StatefulWidget {
  final Match match;

  MatchDetail(this.match);

  @override
  _MatchDetailState createState() => _MatchDetailState(match);
}

class _MatchDetailState extends State<MatchDetail> with SingleTickerProviderStateMixin {
  final Match match;

  _MatchDetailState(this.match);

  TabController _tabController;

  @override
  void initState() {

    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
    _tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(background: MatchHead(match)),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.black,
                    controller: _tabController,
                    tabs: <Widget>[
                      Tab(child: Text("Overview", style: Theme.of(context).textTheme.subhead)),
                      Tab(child: Text("Live Ticker", style: Theme.of(context).textTheme.subhead)),
                      Tab(child: Text("Line-up", style: Theme.of(context).textTheme.subhead)),
                      Tab(child: Text("Stats", style: Theme.of(context).textTheme.subhead)),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bus),
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
