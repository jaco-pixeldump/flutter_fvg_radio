// foundations
import 'package:flutter/material.dart';

// 3rd party
import 'package:path_drawing/path_drawing.dart';
import 'package:provider/provider.dart';

// mine
import 'package:fvg_radio/core/RadioStation.dart';
import 'package:fvg_radio/core/RadioBloc.dart';

class RadioPlayer extends StatefulWidget {
  final RadioStation station;

  RadioPlayer(this.station);

  @override
  _RadioPlayerState createState() => _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer> with TickerProviderStateMixin {
  bool _running = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RadioBloc bloc = Provider.of<RadioBloc>(context, listen: false);

    return GestureDetector(
      onTap: () {
        print('on tap');
        bloc.togglePlayer(playState: !_running, url: widget.station.url);
      },
      child: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<bool>(
              stream: bloc.playStateChange,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) _running = snapshot.data;

                return Container(
                  width: 80,
                  height: 100,
                  child: Stack(
                    children: <Widget>[
                      CustomPaint(
                        painter: RadioStationButton(running: _running),
                      ),
                      Opacity(
                        opacity: .5,
                        child: _running == true
                            ? Image.asset('assets/imgs/rb_anim_run.gif')
                            : Image.asset('assets/imgs/rb_anim_ph.png'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RadioStationButton extends CustomPainter {
  final Path playPath = parseSvgPathData('M -10,-20 18,0 -10,20 Z');
  final Path pausePath = parseSvgPathData('M 5,-19 H 15 V 19 H 5 Z M -15,-19 H -5 V 19 H -15 Z');

  final bool running;
  final Paint icon;
  final Offset center = Offset(40, 40);

  double angle = 0;

  RadioStationButton({this.running})
      : icon = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Color(0xFF444444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    Path p = running == true ? pausePath : playPath;
    canvas.drawCircle(center, 38, circlePaint);
    canvas.drawPath(p.shift(center), icon);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as RadioStationButton).running != running;
  }
}
