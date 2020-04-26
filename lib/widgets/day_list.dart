import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:FlutterFootball/models/day.dart';

import 'package:FlutterFootball/widgets/native_ad.dart';
import 'package:FlutterFootball/widgets/competition_matches_card.dart';

class DayList extends StatefulWidget {
  final List<Day> days;

  const DayList({Key key, this.days}) : super(key: key);

  @override
  DayListState createState() {
    return new DayListState();
  }
}

class DayListState extends State<DayList> {
//  BannerAd myBanner;


  @override
  void initState() {
    super.initState();

//    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
//    myBanner = buildBannerAd()
//      ..load();
  }

  @override
  void dispose() {
//    myBanner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.days.length,
      itemBuilder: (context, i) => Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                DateFormat('EEEE, MMMM d').format(widget.days[i].date),
                style: Theme.of(context).textTheme.headline,
//                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.days[i].dayCompetitionsMatches.length,
            itemBuilder: (context, j) => CompetitionMatchesCard(widget.days[i].dayCompetitionsMatches[j]),
          ),
          NativeAd(),
        ],
      ),
    );
  }
}
