import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsEvent extends Equatable {}

class ShowAdsToggled extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsState extends Equatable {
  final bool showAds;

  const SettingsState({@required this.showAds}) : assert(showAds != null);

  @override
  List<Object> get props => [showAds];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences preferences;

  SettingsBloc({@required this.preferences}) : assert(preferences != null);

  @override
  SettingsState get initialState {
    var showAdsSetting = (preferences.getBool('showAds') ?? true);
    print('initialState (showAds): $showAdsSetting');
    return SettingsState(showAds: showAdsSetting);
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ShowAdsToggled) {
      var showAdsSetting = preferences.getBool('showAds');
      print('ShowAdsToggled: $showAdsSetting');
      await preferences.setBool('showAds', !showAdsSetting);
      yield SettingsState(
        showAds: !showAdsSetting,
      );
    }
  }
}
