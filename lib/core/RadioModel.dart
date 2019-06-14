// foundations
import 'dart:convert';

// mine
import 'package:fvg_radio/core/RadioStation.dart';

///
class RadioModel {
  List<RadioStation> _stations = [];
  int currentStationIndex = 0;

  get stations => _stations;
  get currentStation => _stations[currentStationIndex];

  //
  RadioModel.fromString(String jsonStr){
    Map<String, dynamic> jData = json.decode(jsonStr);

    jData['appConfig']['stations'].forEach((dynamic item){
      RadioStation rs = RadioStation.fromObject(item as Map<String, dynamic>);

      print(item);
      // TODO initialize radio station

      _stations.add(rs);
    });
  }
}