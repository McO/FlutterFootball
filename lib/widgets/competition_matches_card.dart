import 'package:FlutterFootball/models/competition.dart';
import 'package:FlutterFootball/models/day_competiition_matches.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'match_card_item.dart';
import 'package:flutter/services.dart';

class CompetitionMatchesCard extends StatelessWidget {
  final DayCompetitionMatches dayCompetitionMatches;

  const CompetitionMatchesCard(this.dayCompetitionMatches);

  ImageProvider _buildImage(Competition competition) {
    if (competition.logoUrl?.isEmpty ?? true) {
      String path = 'assets/images/competitions/' +  competition.id.toString() + '.png';
      rootBundle.load(path).then((value) {
        return AssetImage(path);
      }).catchError((_) {
        return null;
      });
      return AssetImage(path);
    }
    return NetworkImage(competition.logoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 8, top: 8.0, bottom: 0),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: _buildImage(dayCompetitionMatches.competition),
                          maxRadius: 12,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dayCompetitionMatches.competition.name,
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        dayCompetitionMatches.matchDayName,
                        style: new TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
                      )
                    ],
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
