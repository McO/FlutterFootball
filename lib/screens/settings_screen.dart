import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart' as Preferences;
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
          defaultValue: Constants.showAds,
          onChange: (value) {
            debugPrint(Constants.SETTINGS_SHOW_ADS_KEY + ':' + value.toString());
            Constants.showAds = value;
          },
        ),
      ]),
    );
  }
}
