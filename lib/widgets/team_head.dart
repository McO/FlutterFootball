import 'package:flutter/material.dart';

import 'package:FlutterFootball/widgets/logo_icon.dart';
import '../classes/constants.dart' as Constants;
import '../models/models.dart';

class TeamHead extends StatelessWidget {
  final Team team;

  const TeamHead(this.team);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: Constants.defaultPadding, right: Constants.defaultPadding),
      child: Center(
        child: Column(
          children: [
            LogoIcon(team.logoUrl, 50, true),
//            Padding(
//              padding: const EdgeInsets.symmetric(vertical: Constants.defaultPadding, horizontal: 30),
//              child: Text(
//                team.name,
//                style: TextStyle(fontSize: 12.0, color: Colors.white),
//                textAlign: TextAlign.center,
//              ),
//            )
          ],
        ),
      ),
    );
  }
}
