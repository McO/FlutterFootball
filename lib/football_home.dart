import 'package:flutter/material.dart';

import 'package:FlutterFootball/screens/competitions_screen.dart';
import 'package:FlutterFootball/screens/settings_screen.dart';
import 'screens/matches_screen.dart';

class FootballHome extends StatefulWidget {
  FootballHome();

  @override
  _FootballHomeState createState() => _FootballHomeState();
}

class _FootballHomeState extends State<FootballHome> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Football';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(child: Text("Matches", style: Theme.of(context).textTheme.headline3)),
            Tab(child: Text("Competitions", style: Theme.of(context).textTheme.headline3)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_applications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [MatchesScreen(), CompetitionsScreen()],
      ),
    );
  }
}
