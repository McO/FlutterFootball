import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import '../classes/ads.dart';

class NativeAd extends StatefulWidget {
  @override
  _NativeAdState createState() => _NativeAdState();
}

class _NativeAdState extends State<NativeAd> {
  NativeAdmobController _controller = NativeAdmobController();

  Future<bool> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('showAds') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (context, snapshot) {
        bool _showAd = snapshot.data;
        print('NativeAd _showAd=$_showAd');

        if (_showAd) //state.showAds)
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
      },
    );
  }
}
