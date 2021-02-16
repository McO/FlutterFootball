import 'package:flutter/material.dart';

import 'package:flutter_football/widgets/logo_icon.dart';
import 'package:flutter_football/classes/constants.dart' as Constants;
import 'package:flutter_football/models/models.dart';

class CompetitionHead extends StatelessWidget {
  final Competition competition;

  const CompetitionHead(this.competition);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: Constants.defaultPadding, right: Constants.defaultPadding),
      child: Center(
        child: Column(
          children: [
            LogoIcon(competition.logoUrl, 50, true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Constants.defaultPadding, horizontal: 30),
              child: Text(
                competition.name,
                style: TextStyle(fontSize: 12.0, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
