import 'package:flutter/material.dart';

import 'package:FlutterFootball/models/models.dart' as Models;
import 'package:FlutterFootball/theme/colors.dart';
import 'package:FlutterFootball/widgets/player_picture.dart';

class MatchLiveTickerCard extends StatelessWidget {
  final Models.MatchEvent event;

  MatchLiveTickerCard(this.event);

  @override
  Widget build(BuildContext context) {
    var card = event.data as Models.Card;
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            buildHeader(context, card.type),
            Row(
              children: [
                PlayerPicture(card.booked.pictureUrl, 50),
                Expanded(
                  child: Container(
                    height: 53,
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text(
                              card.booked.name,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ]),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            event.text ?? '',
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontWeight: FontWeight.normal, color: kSecondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context, Models.CardType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Text(
          '${event.minute}\'   ',
          style: Theme.of(context).textTheme.caption,
        ),
        Image(
            image: AssetImage(type == Models.CardType.Yellow
                ? 'assets/images/icons/yellow-card.png'
                : 'assets/images/icons/red-card.png'),
            height: 16),
        Text(
          '   Card for ${event.team.shortName}  ',
          style: Theme.of(context).textTheme.caption,
        ),
        Expanded(child: Divider(color: kSecondaryTextColor))
      ]),
    );
  }
}
