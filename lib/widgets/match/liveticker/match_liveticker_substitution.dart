import 'package:flutter/material.dart';

import 'package:FlutterFootball/models/models.dart' as Models;
import 'package:FlutterFootball/theme/colors.dart';
import 'package:FlutterFootball/widgets/player_picture.dart';

class MatchLiveTickerSubstitution extends StatelessWidget {
  final Models.MatchEvent event;

  MatchLiveTickerSubstitution(this.event);

  @override
  Widget build(BuildContext context) {
    var substitution = event.data as Models.Substitution;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          buildHeader(context),
          Row(
            children: [
              PlayerPicture(substitution.playerIn.pictureUrl, 50),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: PlayerPicture(substitution.playerOut.pictureUrl, 50),
              ),
              Container(
                height: 53,
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      substitution.playerIn.name,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.caption.copyWith(color: Colors.green),
                    ),
                    Text(
                      'for',
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: kSecondaryTextColor, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      substitution.playerOut.name,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.caption.copyWith(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Text(
          '${event.minute}\'   ',
          style: Theme.of(context).textTheme.caption,
        ),
        Image(image: AssetImage('assets/images/icons/substitution.png'), height: 16),
        Text(
          '   Substitution for ${event.team.shortName}  ',
          style: Theme.of(context).textTheme.caption,
        ),
        Expanded(child: Divider(color: kSecondaryTextColor))
        // Text('Goal for ${event.team.name}'),
      ]),
    );
  }
}
