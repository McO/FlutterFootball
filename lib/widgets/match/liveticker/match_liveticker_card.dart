import 'package:flutter/material.dart';

import 'package:flutter_football/models/models.dart' as Models;
import 'package:flutter_football/theme/colors.dart';
import 'package:flutter_football/widgets/player_picture.dart';

class MatchLiveTickerCard extends StatelessWidget {
  final Models.MatchEvent event;

  MatchLiveTickerCard(this.event);

  @override
  Widget build(BuildContext context) {
    var card = event.data as Models.Card;
    return Container(
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
                            card.booked.name ?? '',
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
        if (type == Models.CardType.Yellow || type == Models.CardType.YellowRed)
          Image(image: AssetImage('assets/images/icons/yellow-card.png'), height: 16),
        if (type == Models.CardType.Red || type == Models.CardType.YellowRed)
          Image(image: AssetImage('assets/images/icons/red-card.png'), height: 16),
        Text(
          '   Card for ${event.team.shortName}  ',
          style: Theme.of(context).textTheme.caption,
        ),
        Expanded(child: Divider(color: kSecondaryTextColor))
      ]),
    );
  }
}
