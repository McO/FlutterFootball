import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/logo_icon.dart';
import 'package:FlutterFootball/screens/team_screen.dart';
import 'package:FlutterFootball/widgets/match_detail_status.dart';
import 'package:FlutterFootball/classes/constants.dart' as Constants;
import 'package:FlutterFootball/models/models.dart';

class MatchHead extends StatelessWidget {
  final Match match;

  const MatchHead(this.match);

  Widget buildTeam(BuildContext context, Team team) {
    return Expanded(
      flex: 4,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TeamDetail(team)),
          );
        },
        child: Column(
          children: [
            LogoIcon(team.logoUrl, 50, true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Constants.defaultPadding, horizontal: 30),
              child: Text(
                team.name,
                style: TextStyle(fontSize: 12.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: Constants.defaultPadding, right: Constants.defaultPadding),
      child: Row(
        children: [
          buildTeam(context, match.homeTeam),
          MatchDetailStatus(match),
          buildTeam(context, match.awayTeam),
        ],
      ),
    );
  }
}
