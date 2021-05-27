import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(hours: 1),
    ));
//    remoteConfig.setDefaults(<String, dynamic>{
//      'welcome': 'default welcome',
//      'hello': 'default hello',
//    });
    await remoteConfig.fetchAndActivate();
    return remoteConfig;
  }
}
