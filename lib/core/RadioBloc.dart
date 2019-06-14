import 'dart:async';
import 'package:flutter/services.dart';

// 3rd party
import 'package:rxdart/rxdart.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

// mine
import 'package:fvg_radio/core/RadioModel.dart';
import 'package:fvg_radio/core/RadioStation.dart';

///
class RadioBloc{

  RadioModel _model;
  AudioPlayer _player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  PublishSubject<bool> _configLoaded = PublishSubject<bool>();
  Stream<bool> get configLoaded => _configLoaded.stream;

  PublishSubject<bool> _playStateChange = PublishSubject<bool>();
  Stream<bool> get playStateChange => _playStateChange.stream;

  get stations => _model?.stations ?? [];
  get currentStation => _model.currentStation;

  // the constructor (well, one of ...)
  RadioBloc(){
    AudioPlayer.logEnabled = true;
    _loadConfig();
  }

  Future<void> _loadConfig() async{
    String jsonStr = await rootBundle.loadString('assets/json/app_config.json');
    _model = RadioModel.fromString(jsonStr);

    print('done with config: $jsonStr');
    _configLoaded.add(true);
  }

  void setCurrentStationIndex(int stationIndex){
    if(stationIndex == _model.currentStationIndex) return; // only by change
    togglePlayer();
    _model.currentStationIndex = stationIndex;
  }

  void togglePlayer({bool playState = false, String url = ''}){
    print('$playState, $url');

    if(playState == true && _player.state == AudioPlayerState.PLAYING) return;
    if(playState == false && _player.state != AudioPlayerState.PLAYING) return;
    if(playState == true && url.length < 16) return;

    if(playState == true){
      _player.play(url);
    }
    else _player.stop();

    _playStateChange.add(playState);
  }

  void dispose(){
    _configLoaded.close();
    _playStateChange.close();
  }
}