import 'package:flutter/material.dart';

import 'package:flutter_football/models/models.dart';

class TeamNews extends StatelessWidget {
  final Team team;

  const TeamNews(this.team);

  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("News")));
  }
}
