import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {}

class ShowAdsToggled extends SettingsEvent {
  @override
  List<Object> get props => [];
}

class SettingsState extends Equatable {
  final bool showAds;

  const SettingsState({@required this.showAds})
      : assert(showAds != null);

  @override
  List<Object> get props => [showAds];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  @override
  SettingsState get initialState =>
      SettingsState(showAds: true);

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ShowAdsToggled) {
      yield SettingsState(
        showAds: !state.showAds,
      );
    }
  }
}