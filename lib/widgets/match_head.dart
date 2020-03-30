import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../Constants.dart' as Constants;
import '../models/match.dart';
import '../models/team.dart';

class MatchHead extends StatelessWidget {
  final Match match;

  const MatchHead(this.match);

  ImageProvider _buildImage(Team team) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 70, left: Constants.defaultPadding, right: Constants.defaultPadding),
      child: new Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: _buildImage(match.homeTeam),
                  maxRadius: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Text(match.homeTeam.name, style: TextStyle(fontSize: 12.0, color: Colors.white)),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(match.score.home.toString() + " : " + match.score.away.toString(),
                    style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: _buildImage(match.awayTeam),
                  maxRadius: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Text(match.awayTeam.name, style: TextStyle(fontSize: 12.0, color: Colors.white)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
