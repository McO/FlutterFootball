import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:FlutterFootball/screens/match_screen.dart';
import 'package:flutter_svg/svg.dart';
import '../classes/constants.dart' as Constants;
import 'package:FlutterFootball/models/models.dart';

class MatchCardItem extends StatelessWidget {
  final Match match;

  const MatchCardItem(this.match);

  Widget _buildImage(Team team) {
    try {
      if (team.logoUrl != null && team.logoUrl.isNotEmpty) {
        if (team.logoUrl.toLowerCase().endsWith('.svg')) {
          return SvgPicture.network(
            team.logoUrl,
            height: 30,
          );
        }
        if (team.logoUrl.toLowerCase().endsWith('.png')) {
          return Image.network(
            team.logoUrl,
            height: 30,
          );
        }
      }
    }
    catch (e)
    {
      print('Exception in _buildImage for ${team.id}: $e');
    }

    return Container();


//    try {
//      if (team.logoUrl?.isEmpty ?? true) {
//        String path = 'assets/images/teams/' + team.id.toString() + '.png';
//        rootBundle.load(path).then((value) {
//          return CircleAvatar(
//            backgroundColor: Colors.grey,
//            backgroundImage: AssetImage(path),
//            maxRadius: 8,
//          );
//        }).catchError((_) {
//          return null;
//        });
////      return AssetImage(path);
//      }
//    } catch (_) {}
//
//    try {
//      return SvgPicture.network(
//        team.logoUrl ?? '',
//        height: 30,
//      );
//    } catch (_) {}
//
//    return Image.network(team.logoUrl);
  }

  Widget _buildMatchRow(BuildContext context, Team team, int score) {
    return new Row(
      children: <Widget>[
        Container(padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0), width: 35, child: _buildImage(team)),
        Expanded(
          child: Text(
            team.name,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.body1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: Constants.defaultPadding),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatchDetail(match)),
        );
      },
      child: new Row(
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
              height: 36,
              child: VerticalDivider(
                width: 5,
              )),
          Container(
            width: 80,
            child: Center(
              child: Text(match.time),
            ),
          ),
        ],
      ),
    );
  }
}
