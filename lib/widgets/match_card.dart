import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/match_model.dart';
import '../models/team_model.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;

  const MatchCard(this.match);

  ImageProvider _buildImage(TeamModel team) {
    if (team.logoUrl?.isEmpty ?? true) {
      String path = 'assets/images/teams/' + team.id.toString() + '.png';
      rootBundle.load(path).then((value) {
        return AssetImage(path);
      }).catchError((_) {
        return null;
      });
      return AssetImage(path);
    }
    return NetworkImage(team.logoUrl);
  }

  Widget _buildMatchRow(TeamModel team, int score) {
    return new Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
          width: 35,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _buildImage(team),
            maxRadius: 8,
          ),
        ),
        Expanded(
          child: Text(
            team.name,
            textAlign: TextAlign.start,
            style:
                new TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            score.toString(),
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildMatchRow(match.homeTeam, match.score.home),
              _buildMatchRow(match.awayTeam, match.score.away),
            ],
          ),
        ),
        Container(
            height: 36,
            child: VerticalDivider(
              width: 5,
            )),
        Container(
          width: 80,
          child: Center(
            child: Text(
              match.time,
              style: new TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }
}
