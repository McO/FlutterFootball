import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:FlutterFootball/simple_bloc_delegate.dart';
import 'package:FlutterFootball/classes/config.dart';

//import 'package:FlutterFootball/classes/routes.dart';
import 'package:FlutterFootball/football_home.dart';
import 'package:FlutterFootball/theme/style.dart';
import 'package:FlutterFootball/blocs/blocs.dart';
import 'package:FlutterFootball/classes/cache_provider.dart';
import 'package:FlutterFootball/repositories/repositories.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'data/api_dao.dart';

Future<Null> main() async {
  await initSettings();
  WidgetsFlutterBinding.ensureInitialized();

  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  await remoteConfig.fetch(expiration: const Duration(hours: 5));
  await remoteConfig.activateFetched();
  final SharedPreferences preferences = await SharedPreferences.getInstance();

  final String authTokenFootballDat =
      remoteConfig?.getString('football_data_api_token');
  final String authTokenApiFootball =
      remoteConfig?.getString('api_football_api_token');

  final ApiDao apiDao = ApiDao();

  final FootballDataRepository footballDataRepository = FootballDataRepository(
    footballDataClient: FootballDataClient(
        httpClient: http.Client(),
        authToken: authTokenFootballDat,
        apiDao: apiDao),
  );
  final ApiFootballRepository apiFootballRepository = ApiFootballRepository(
    apiFootballClient: ApiFootballClient(
        httpClient: http.Client(),
        authToken: authTokenApiFootball,
        apiDao: apiDao),
  );

//  final teams = footballDataRepository.teams();

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CompetitionsBloc>(
          create: (context) => CompetitionsBloc(
              footballDataRepository: footballDataRepository,
              apiFootballRepository: apiFootballRepository),
        ),
        BlocProvider<MatchesBloc>(
          create: (context) => MatchesBloc(
              footballDataRepository: footballDataRepository,
              apiFootballRepository: apiFootballRepository,
              dummyFootballRepository: DummyFootballRepository()),
        ),
        BlocProvider<MatchStatisticsBloc>(
          create: (context) => MatchStatisticsBloc(
              footballDataRepository: footballDataRepository,
              apiFootballRepository: apiFootballRepository,
              dummyFootballRepository: DummyFootballRepository()),
        ),
        BlocProvider<MatchEventsBloc>(
          create: (context) => MatchEventsBloc(
              footballDataRepository: footballDataRepository,
              apiFootballRepository: apiFootballRepository,
              dummyFootballRepository: DummyFootballRepository()),
        ),
        BlocProvider<MatchLineupsBloc>(
          create: (context) => MatchLineupsBloc(
              footballDataRepository: footballDataRepository,
              apiFootballRepository: apiFootballRepository,
              dummyFootballRepository: DummyFootballRepository()),
        ),
        BlocProvider<StandingsBloc>(
          create: (context) => StandingsBloc(
              footballDataRepository: footballDataRepository,
              apiFootballRepository: apiFootballRepository),
        ),
        BlocProvider<CompetitionRoundBloc>(
          create: (context) => CompetitionRoundBloc(
              footballDataRepository: footballDataRepository,
              apiFootballRepository: apiFootballRepository),
        ),
      ],
      child: App(),
    ),
  );
}

bool _isUsingHive = true;

Future<void> initSettings() async {
  await Settings.init(
    cacheProvider: _isUsingHive ? HiveCache() : SharePreferenceCache(),
  );
}


class App extends StatelessWidget {
  App({Key key}) : super(key: key);

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
