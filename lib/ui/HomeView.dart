// foundations
import 'package:flutter/material.dart';

// 3rd party
import 'package:provider/provider.dart';

// mine
import 'package:fvg_radio/core/RadioStation.dart';
import 'package:fvg_radio/core/RadioBloc.dart';
import 'package:fvg_radio/ui/CardFlipper.dart';
import 'package:fvg_radio/ui/RadioPlayer.dart';
import 'package:fvg_radio/ui/bottom_section.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  double scrollPercent = 0.0;
  RadioBloc bloc;

  _updateStationIndex(double scrollPercent){
    int currentIndex = (scrollPercent / (1.0 / bloc.stations.length)).round();
    bloc.setCurrentStationIndex(currentIndex);

    print('got currentIndex: $currentIndex');

    setState(() => this.scrollPercent = scrollPercent);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RadioBloc>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<bool>(
          stream: bloc.configLoaded,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 20,
                  ),
                  Expanded(
                    child: CardFlipper(
                      stations: bloc.stations,
                      onScroll: (double scrollPercent) {
                        _updateStationIndex(scrollPercent);
                      },
                    ),
                  ),
                  BottomSection(
                    itemCount: bloc.stations.length,
                    scrollPercent: scrollPercent,
                  ),
                  RadioPlayer(bloc.currentStation),
                ],
              );
            }
            return Center(
              child: Text('loading',
                  style: TextStyle(
                    color: Colors.white,
                  ),
              ),
            );
          }),
    );
  }
}
