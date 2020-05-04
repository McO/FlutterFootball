import 'package:flutter/material.dart';

import '../models/models.dart' as Models;

class MatchDetailStatus extends StatelessWidget {
  final Models.Match match;

  const MatchDetailStatus(this.match);

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
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14, color: Colors.orange),
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(match.score.home.toString() + " : " + match.score.away.toString(), style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          );
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
