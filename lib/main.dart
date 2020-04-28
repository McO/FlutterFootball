import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:FlutterFootball/simple_bloc_delegate.dart';
import 'package:FlutterFootball/classes/config.dart';
//import 'package:FlutterFootball/classes/routes.dart';
import 'package:FlutterFootball/football_home.dart';
import 'package:FlutterFootball/theme/style.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:provider/provider.dart';
import 'blocs/blocs.dart';
import 'classes/cache_provider.dart';
import 'classes/config.dart';
import 'package:FlutterFootball/repositories/repositories.dart';

Future<Null> main() async {
  await initSettings();
  WidgetsFlutterBinding.ensureInitialized();

  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  String authToken = remoteConfig?.getString('football_data_api_token');

  final FootballDataRepository footballDataRepository = FootballDataRepository(
    footballDataClient: FootballDataClient(httpClient: http.Client(), authToken: authToken),
  );

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider<CompetitionBloc>(
          create: (context) => CompetitionBloc(footballDataRepository: footballDataRepository),
        ),
      ],
      child: App(footballDataRepository: footballDataRepository),
    ),
  );
}

Future<void> initSettings() async {
  await Settings.init(
    cacheProvider: _isUsingHive ? HiveCache() : SharePreferenceCache(),
  );
}

bool _isUsingHive = true;

class App extends StatelessWidget {
  final FootballDataRepository footballDataRepository;

  App({Key key, @required this.footballDataRepository})
      : assert(footballDataRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = 'Football';

    return MultiProvider(
      providers: [
        Provider<Config>(create: (_) => Config()),
      ],
      child: MaterialApp(
        title: title,
        theme: buildThemeData(),
        home: FootballHome(),
      ),
    );
  }
}
