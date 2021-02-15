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
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
