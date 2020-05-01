import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/logo_icon.dart';
import '../classes/constants.dart' as Constants;
import '../models/models.dart';

class MatchHead extends StatelessWidget {
  final Match match;

  const MatchHead(this.match);

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
                LogoIcon(match.homeTeam.logoUrl, 50),
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
//                Image(
//                  image: _buildImage(match.awayTeam),
//                  height: 50,
//                  width: 80,
//                ),
                LogoIcon(match.awayTeam.logoUrl, 50),
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
