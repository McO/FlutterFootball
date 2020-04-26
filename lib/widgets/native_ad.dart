import 'package:FlutterFootball/classes/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:provider/provider.dart';
import '../classes/ads.dart';

class NativeAd extends StatefulWidget {
  @override
  _NativeAdState createState() => _NativeAdState();
}

class _NativeAdState extends State<NativeAd> {
  NativeAdmobController _controller = NativeAdmobController();

  @override
  Widget build(BuildContext context) {
    if (Provider.of<Config>(context, listen: false).showAds)
      return Container(
        height: 250,
        child: NativeAdmob(
          adUnitID: AdsConfiguration.getNativeAdUnitId(),
          loading: Center(child: CircularProgressIndicator()),
          error: Text("Failed to load the ad"),
          controller: _controller,
          type: NativeAdmobType.full,
          options: NativeAdmobOptions(
            ratingColor: Colors.red,
            // Others ...
          ),
        ),
      );
    return Container();
  }
}
