import 'package:flutter/material.dart';

import '../models/models.dart' as Models;

class MatchStatus extends StatelessWidget {
  final Models.Match match;

  const MatchStatus(this.match);

  @override
  Widget build(BuildContext context) {
    switch (match.status) {
      case Models.MatchStatus.Postponed:
      case Models.MatchStatus.Cancelled:
      case Models.MatchStatus.Suspended:
        {
          var index = match.status.toString().lastIndexOf('.') + 1;
          var status = match.status.toString().substring(index);
          return Text(
            '!\n$status',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10, color: Colors.orange),
            textAlign: TextAlign.center,
          );
        }
        break;

      case Models.MatchStatus.Scheduled:
        {
          return Text(match.time);
        }
        break;

      case Models.MatchStatus.Finished:
        {
          return Text('Full Time');
        }
        break;

      default:
        {
          return Text('');
        }
        break;
    }

    return Text('');
  }
}
