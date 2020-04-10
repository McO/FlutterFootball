import 'package:FlutterFootball/classes/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as Preferences;
import 'package:provider/provider.dart';
import '../classes/constants.dart' as Constants;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Preferences.SettingsScreen(title: "Application Settings", children: [
        Preferences.SwitchSettingsTile(
          settingKey: Constants.SETTINGS_SHOW_ADS_KEY,
          title: 'Show Ads',
          defaultValue: Provider.of<Config>(context, listen: false)?.showAds,
          onChange: (value) {
            debugPrint(Constants.SETTINGS_SHOW_ADS_KEY + ':' + value.toString());
            Provider.of<Config>(context, listen: false)?.showAds = value;
          },
        ),
      ]),
    );
  }
}
