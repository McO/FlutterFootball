import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:FlutterFootball/models/models.dart' as Models;
import 'match_card_item.dart';
import 'package:FlutterFootball/screens/competition_screen.dart';
import 'package:FlutterFootball/widgets/logo_icon.dart';
import 'package:FlutterFootball/classes/constants.dart' as Constants;

class CompetitionMatchesCard extends StatelessWidget {
  final Models.DayCompetitionMatches dayCompetitionMatches;
  final bool showCompetitionHead;

  const CompetitionMatchesCard(this.dayCompetitionMatches, {this.showCompetitionHead = true})
      : assert(showCompetitionHead != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (showCompetitionHead)
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CompetitionDetail(dayCompetitionMatches.competition, 1)),
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: Constants.defaultPadding),
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
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dayCompetitionMatches.matches.length,
              itemBuilder: (context, k) => Column(
                children: [
                  Divider(
                    height: 10.0,
                  ),
                  MatchCardItem(dayCompetitionMatches.matches[k])
                ],
              ),
            ),
          ),
          buildStandingsLink(context, dayCompetitionMatches.competition)
        ],
      ),
    );
  }
}

Widget buildStandingsLink(BuildContext context, Models.Competition competition) {
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
                  MaterialPageRoute(builder: (context) => CompetitionDetail(competition, 2)),
                )
              },
          child: Text(
            'See Standings',
            style: Theme.of(context).textTheme.subtitle2,
          )),
    ),
  ]);
}
