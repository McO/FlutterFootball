import 'package:flutter/material.dart';

import 'package:flutter_football/models/models.dart' as Models;

class MatchLiveTickerItem extends StatelessWidget {
  final Models.MatchEvent event;

  MatchLiveTickerItem(this.event);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(
        '${event.minute}\'',
        style: Theme.of(context).textTheme.caption,
      ),
      Expanded(child: Divider(color: Colors.black)),
      // Text('${event.team.name}'),
    ]);
  }
}
