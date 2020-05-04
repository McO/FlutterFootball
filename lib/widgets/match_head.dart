import 'package:FlutterFootball/widgets/match_detail_status.dart';
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
                LogoIcon(match.homeTeam.logoUrl, 50, true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Constants.defaultPadding, horizontal: 30),
                  child: Text(
                    match.homeTeam.name,
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          MatchDetailStatus(match),
          Expanded(
            flex: 4,
            child: Column(
              children: [
//                Image(
//                  image: _buildImage(match.awayTeam),
//                  height: 50,
//                  width: 80,
//                ),
                LogoIcon(match.awayTeam.logoUrl, 50, true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Constants.defaultPadding, horizontal: 30),
                  child: Text(
                    match.awayTeam.name,
                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
