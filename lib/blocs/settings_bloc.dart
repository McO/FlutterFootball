import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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

  SettingsBloc();

  @override
  SettingsState get initialState {
    var showAdsSetting = Settings.getValue<bool>('showAds', true);
    print('initialState (showAds): $showAdsSetting');
    return SettingsState(showAds: showAdsSetting);
  }

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ShowAdsToggled) {
      var showAdsSetting = Settings.getValue<bool>('showAds', true);
      print('ShowAdsToggled: $showAdsSetting');
      Settings.getValue<bool>('showAds', !showAdsSetting);
      yield SettingsState(
        showAds: !showAdsSetting,
      );
    }
  }
}
