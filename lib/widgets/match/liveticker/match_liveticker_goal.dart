import 'package:flutter/material.dart';

import 'package:FlutterFootball/models/models.dart' as Models;
import 'package:FlutterFootball/theme/colors.dart';
import 'package:FlutterFootball/widgets/player_picture.dart';

class MatchLiveTickerGoal extends StatelessWidget {
  final Models.MatchEvent event;

  MatchLiveTickerGoal(this.event);

  @override
  Widget build(BuildContext context) {
    var goal = event.data as Models.Goal;
    return Container(
      decoration: new BoxDecoration(color: kHighlightBackgroundColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          buildHeader(context),
          Row(
            children: [
              PlayerPicture(goal.scorer.pictureUrl, 50),
              Expanded(
                child: Container(
                  height: 53,
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            goal.scorer.name ?? '',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        Container(
                          width: 50.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(
                              width: 1.5,
                              color: Color(0xFFFF000000),
                            ),
                          ),
                          child: Center(
                              child: Text('${goal.score.home} : ${goal.score.away}',
                                  style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ]),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          getAssist(goal),
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

  Padding buildHeader(BuildContext context) {
    var goal = event.data as Models.Goal;
    var additionalInfo = '';
    if (goal.type == Models.GoalType.OwnGoal) additionalInfo = '(Own Goal)  ';
    if (goal.type == Models.GoalType.Penalty) additionalInfo = '(Penalty)  ';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Text(
          '${event.minute}\'   ',
          style: Theme.of(context).textTheme.caption,
        ),
        Image(image: AssetImage('assets/images/icons/soccer-ball.png')),
        Text(
          '   Goal for ${event.team.shortName}  $additionalInfo',
          style: Theme.of(context).textTheme.caption,
        ),
        Expanded(
            flex: 1,
            child: Divider(
              color: Colors.black,
              thickness: 1.5,
            ))
        // Text('Goal for ${event.team.name}'),
      ]),
    );
  }

  String getAssist(Models.Goal goal) {
    if (goal.assist != null && goal.assist.name != null) return 'Assist: ${goal.assist.name}';
    return '';
  }
}
