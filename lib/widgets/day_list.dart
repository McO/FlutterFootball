import 'package:flutter/material.dart';
import 'dart:io';

import 'package:FlutterFootball/models/day.dart';
import 'package:FlutterFootball/widgets/competition_matches_card.dart';
import 'package:intl/intl.dart';
import 'package:firebase_admob/firebase_admob.dart';



class DayList extends StatefulWidget {
  final List<Day> days;

  const DayList({Key key, this.days}) : super(key: key);

  @override
  DayListState createState() {
    return new DayListState();
  }
}

class DayListState extends State<DayList> {
  BannerAd myBanner;


  String getAppId() {
    if (Platform.isIOS) {
      return "IOS_APP_ID";
    } else if (Platform.isAndroid) {
      return "com.rasp.flutterfootball";
    }
    return null;
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return "IOS_AD_UNIT_BANNER";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-4679672544714691/7264916502";
    }
    return null;
  }

  BannerAd buildBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.fullBanner,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.loaded) {
            myBanner..show();
          }
        });
  }


//  BannerAd createBannerAd() {
//    return BannerAd(
//      adUnitId: getBannerAdUnitId(),
//      size: AdSize.banner,
////      targetingInfo: targetingInfo,
//      listener: (MobileAdEvent event) {
//        print("BannerAd event $event");
//      },
//    );
//  }

  @override
  void initState() {
    super.initState();

    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    myBanner = buildBannerAd()
      ..load();
  }

  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.days.length,
      itemBuilder: (context, i) =>
      new Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                DateFormat('EEEE, MMMM d').format(widget.days[i].date),
                style: Theme
                    .of(context)
                    .textTheme
                    .headline,
//                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              )),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.days[i].dayCompetitionsMatches.length,
            itemBuilder: (context, j) => CompetitionMatchesCard(widget.days[i].dayCompetitionsMatches[j]),
          ),
        ],
      ),
    );
  }
}