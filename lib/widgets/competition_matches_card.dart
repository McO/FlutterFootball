import 'package:FlutterFootball/models/day_competiition_matches.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'match_card_item.dart';

class CompetitionMatchesCard extends StatelessWidget {
  final DayCompetitionMatches dayCompetitionMatches;

  const CompetitionMatchesCard(this.dayCompetitionMatches);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 18, top: 8.0, bottom: 0),
              child: Row(
                children: <Widget>[
                  Text(
                    dayCompetitionMatches.competition.name,
                    textAlign: TextAlign.start,
                    style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new ListView.builder(
              shrinkWrap: true,
              itemCount: dayCompetitionMatches.matches.length,
              itemBuilder: (context, k) => new Column(
                children: <Widget>[
                  new Divider(
                    height: 10.0,
                  ),
                  new MatchCardItem(dayCompetitionMatches.matches[k])
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
