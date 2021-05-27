import 'dart:async';

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
  final NativeAdmobController _controller = NativeAdmobController();
  double _height = 0;

  Future<bool> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('showAds') ?? true;
  }

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _controller.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _height = 330;
        });
        break;

      default:
        break;
    }
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
            height: _height,
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
