import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:FlutterFootball/models/day.dart';

import 'package:FlutterFootball/widgets/native_ad.dart';
import 'package:FlutterFootball/widgets/matches/competition_matches_card.dart';

class DayList extends StatefulWidget {
  final List<Day> days;
  final bool showCompetitionHead;

  const DayList({Key key, this.days, this.showCompetitionHead = true}) : super(key: key);

  @override
  DayListState createState() {
    return new DayListState();
  }
}

class DayListState extends State<DayList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // padding: const EdgeInsets.symmetric(vertical: 0.0),
      itemCount: widget.days.length,
      itemBuilder: (context, i) => Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                localizeDate(widget.days[i].date),
                style: Theme.of(context).textTheme.headline5,
//                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.days[i].dayCompetitionsMatches.length,
            itemBuilder: (context, j) => CompetitionMatchesCard(widget.days[i].dayCompetitionsMatches[j],
                showCompetitionHead: widget.showCompetitionHead),
          ),
          NativeAd(),
        ],
      ),
    );
  }

  String localizeDate(DateTime date) {
    var now = new DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var yesterday = today.subtract(Duration(days: 1));
    var tomorrow = today.add(Duration(days: 1));
    if (date == yesterday) return 'Yesterday';
    if (date == today) return 'Today';
    if (date == tomorrow) return 'Tomorrow';
    return DateFormat('EEEE, MMMM d').format(date);
  }
}
