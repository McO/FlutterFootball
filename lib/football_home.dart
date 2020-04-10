import 'package:FlutterFootball/screens/settings_screen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'screens/matches_screen.dart';

class FootballHome extends StatefulWidget {
  FootballHome({this.remoteConfig});

  final RemoteConfig remoteConfig;

  @override
  _FootballHomeState createState() => _FootballHomeState();
}

class _FootballHomeState extends State<FootballHome> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 1);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Football';
    title = widget.remoteConfig?.getString('title');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0.7,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(child: Text("Matches", style: Theme.of(context).textTheme.display1)),
          ],
        ),
        actions: <Widget>[
          Icon(Icons.search),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
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
        children: <Widget>[MatchesScreen()],
      ),
    );
  }
}
