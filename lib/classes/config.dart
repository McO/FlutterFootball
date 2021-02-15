import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config {
  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // Enable developer mode to relax fetch throttling
    remoteConfig.setConfigSettings(RemoteConfigSettings());
//    remoteConfig.setDefaults(<String, dynamic>{
//      'welcome': 'default welcome',
//      'hello': 'default hello',
//    });
    await remoteConfig.fetch(expiration: const Duration(hours: 5));
    await remoteConfig.activateFetched();
    return remoteConfig;
  }
}
