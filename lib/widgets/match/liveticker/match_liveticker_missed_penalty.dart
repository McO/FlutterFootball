import 'package:flutter/material.dart';

import 'package:flutter_football/models/models.dart' as Models;
import 'package:flutter_football/theme/colors.dart';
import 'package:flutter_football/widgets/player_picture.dart';

class MatchLiveTickerMissedPenalty extends StatelessWidget {
  final Models.MatchEvent event;

  MatchLiveTickerMissedPenalty(this.event);

  @override
  Widget build(BuildContext context) {
    var missedPenalty = event.data as Models.MissedPenalty;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          buildHeader(context),
          Row(
            children: [
              PlayerPicture(missedPenalty.shooter.pictureUrl, 50),
              Expanded(
                child: Container(
                  height: 53,
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          child: Text(
                            missedPenalty.shooter.name,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Padding buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Text(
          '${event.minute}\'   ',
          style: Theme.of(context).textTheme.caption,
        ),
        // Image(image: AssetImage('assets/images/icons/soccer-ball.png')),
        Text(
          '   Missed Penalty for ${event.team.shortName}  ',
          style: Theme.of(context).textTheme.caption,
        ),
        Expanded(child: Divider(color: kSecondaryTextColor))
      ]),
    );
  }
}
