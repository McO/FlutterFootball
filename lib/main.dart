import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

//import 'package:flutter_football/simple_bloc_delegate.dart';
import 'package:flutter_football/classes/config.dart';

//import 'package:flutter_football/classes/routes.dart';
import 'package:flutter_football/football_home.dart';
import 'package:flutter_football/theme/style.dart';
import 'package:flutter_football/blocs/blocs.dart';
import 'package:flutter_football/classes/cache_provider.dart';
import 'package:flutter_football/repositories/repositories.dart';

//import 'package:shared_preferences/shared_preferences.dart';

import 'data/api_dao.dart';

Future<Null> main() async {
  await initSettings();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // MobileAds.instance.initialize();

  RemoteConfig remoteConfig = RemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  //final SharedPreferences preferences = await SharedPreferences.getInstance();

  final String authTokenFootballDat = remoteConfig?.getString('football_data_api_token');
  final String authTokenApiFootball = remoteConfig?.getString('api_football_api_token');

  final ApiDao apiDao = ApiDao();

  final FootballDataRepository footballDataRepository = FootballDataRepository(
    footballDataClient: FootballDataClient(httpClient: http.Client(), authToken: authTokenFootballDat, apiDao: apiDao),
  );
  final ApiFootballRepository apiFootballRepository = ApiFootballRepository(
    apiFootballClient: ApiFootballClient(httpClient: http.Client(), authToken: authTokenApiFootball, apiDao: apiDao),
  );

  //  final teams = footballDataRepository.teams();

  //Breaking change: https://pub.dev/packages/bloc/changelog#500-dev8
  //BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CompetitionsBloc>(
          create: (context) => CompetitionsBloc(
              footballDataRepository: footballDataRepository, apiFootballRepository: apiFootballRepository),
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
              footballDataRepository: footballDataRepository, apiFootballRepository: apiFootballRepository),
        ),
        BlocProvider<CompetitionRoundBloc>(
          create: (context) => CompetitionRoundBloc(
              footballDataRepository: footballDataRepository, apiFootballRepository: apiFootballRepository),
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

    return provider.MultiProvider(
      providers: [
        provider.Provider<Config>(create: (_) => Config()),
      ],
      child: MaterialApp(
        title: title,
        theme: buildThemeData(),
        home: FootballHome(),
      ),
    );
  }
}
