import 'package:FlutterFootball/classes/config.dart';
import 'package:FlutterFootball/classes/routes.dart';
import 'package:FlutterFootball/football_home.dart';
import 'package:FlutterFootball/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:provider/provider.dart';
import 'classes/cache_provider.dart';
import 'classes/config.dart';

Future<Null> main() async {
  await initSettings();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FootballApp());
}

Future<void> initSettings() async {
  await Settings.init(
    cacheProvider: _isUsingHive ? HiveCache() : SharePreferenceCache(),
  );
}

bool _isUsingHive = true;

class FootballApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String title = 'Football';
    Config config = Config();

    return MultiProvider(
      providers: [
        Provider<Config>(create: (_) => Config()),
      ],
      child: new MaterialApp(
        title: title,
        theme: buildThemeData(),
        debugShowCheckedModeBanner: false,
//      initialRoute: '/',
        routes: routes,
//        home: FootballHome(remoteConfig: null),
        home: FutureBuilder<RemoteConfig>(
          future: config.setupRemoteConfig(),
          builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
            return snapshot.hasData
                ? FootballHome(remoteConfig: snapshot.data)
                : Container();
          },
        )
      ),
    );
  }
}

