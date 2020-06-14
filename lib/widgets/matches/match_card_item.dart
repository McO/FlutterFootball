import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/logo_icon.dart';
import 'package:FlutterFootball/widgets/matches/match_status.dart';

import 'package:FlutterFootball/screens/match_screen.dart';
import 'package:FlutterFootball/classes/constants.dart' as Constants;
import 'package:FlutterFootball/models/models.dart' as Models;

class MatchCardItem extends StatelessWidget {
  final Models.Match match;

  const MatchCardItem(this.match);

  Widget _buildMatchRow(BuildContext context, Models.Team team, int score) {
    return new Row(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
            width: 35,
            child: LogoIcon(team.logoUrl, 30, false)),
        Expanded(
          child: Text(
            team.name,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: Constants.defaultPadding),
          child: Text(
            score == null ? '' : score.toString(),
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchDetail(match)),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildMatchRow(context, match.homeTeam, match.score.home),
                _buildMatchRow(context, match.awayTeam, match.score.away),
              ],
            ),
          ),
          Container(
              height: 50,
              child: VerticalDivider(
                color: Theme.of(context).dividerColor,
                width: 5,
              )),
          Container(
            width: 80,
            child: Center(
              child: MatchStatus(match),
            ),
          ),
        ],
      ),
    );
  }
}
