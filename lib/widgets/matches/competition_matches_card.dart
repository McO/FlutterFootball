import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:FlutterFootball/models/models.dart' as Models;
import 'match_card_item.dart';
import 'package:FlutterFootball/screens/competition_screen.dart';
import 'package:FlutterFootball/widgets/logo_icon.dart';
import 'package:FlutterFootball/classes/constants.dart' as Constants;

class CompetitionMatchesCard extends StatelessWidget {
  final Models.DayCompetitionMatches dayCompetitionMatches;

  const CompetitionMatchesCard(this.dayCompetitionMatches);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompetitionDetail(dayCompetitionMatches.competition, 0)),
                );
              },
              child: Container(
                  padding:
                      const EdgeInsets.only(left: Constants.defaultPadding, top: Constants.defaultPadding, bottom: 0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: Constants.defaultPadding),
                              child: LogoIcon(dayCompetitionMatches.competition.logoUrl, 20, true)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayCompetitionMatches.competition.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            dayCompetitionMatches.matchDayName,
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      )
                    ],
                  ))),
          Padding(
            padding: const EdgeInsets.only(
                left: Constants.defaultPadding, right: Constants.defaultPadding, bottom: Constants.defaultPadding),
            child: new ListView.builder(
              physics: new NeverScrollableScrollPhysics(),
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
          buildStndingsLink(context, dayCompetitionMatches.competition)
        ],
      ),
    );
  }
}

Widget buildStndingsLink(BuildContext context, Models.Competition competition) {
  if (!competition.hasStandings) return Container();

  return Column(children: [
    Divider(
      height: 0,
    ),
    SizedBox(
      width: double.infinity,
      child: FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompetitionDetail(competition, 1)),
                )
              },
          child: Text(
            'See Standings',
            style: Theme.of(context).textTheme.subtitle2,
          )),
    ),
  ]);
}
