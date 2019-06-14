// foundations
import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

// 3rd party

// mine
import 'package:fvg_radio/core/RadioStation.dart';
import 'package:fvg_radio/ui/FlipCard.dart';

//
class CardFlipper extends StatefulWidget {
  final List<RadioStation> stations;
  final Function onScroll;

  CardFlipper({
    this.stations,
    this.onScroll,
  });

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> with TickerProviderStateMixin {
  double scrollPercent = 0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;

  @override
  void initState() {
    super.initState();

    finishScrollController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(finishScrollStart, finishScrollEnd, finishScrollController.value);

          if (widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {});
  }

  void _onPanStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    final dragDistance = currDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size.width;

    setState(() {
      scrollPercent =
          (startDragPercentScroll + (-singleCardDragPercent / widget.stations.length)).clamp(0, 1 - (1 / widget.stations.length));
      print('percentScroll: $scrollPercent');

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * widget.stations.length).round() / widget.stations.length;
    finishScrollController.forward(from: 0);

    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  List<Widget> _buildCards() {
    int index = 0;

    List<Widget> widgets = [];

    widget.stations.forEach((RadioStation station) {
      widgets.add(_buildCard(station, index++, widget.stations.length, scrollPercent));
    });

    return widgets;
  }

  Matrix4 _buildCardProjection(double scrollPercent) {
    // Pre-multiplied matrix of a projection matrix and a view matrix.
    //
    // Projection matrix is a simplified perspective matrix
    // http://web.iitd.ac.in/~hegde/cad/lecture/L9_persproj.pdf
    // in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, 0.0],
    //  [0.0, 0.0, -perspective, 1.0]]
    //
    // View matrix is a simplified camera view matrix.
    // Basically re-scales to keep object at original size at angle = 0 at
    // any radius in the form of
    // [[1.0, 0.0, 0.0, 0.0],
    //  [0.0, 1.0, 0.0, 0.0],
    //  [0.0, 0.0, 1.0, -radius],
    //  [0.0, 0.0, 0.0, 1.0]]
    final double perspective = 0.002;
    final double radius = 1;
    final double angle = scrollPercent * pi / 8;
    final double horizontalTranslation = 0;
    Matrix4 projection = Matrix4.identity()
      ..setEntry(0, 0, 1 / radius)
      ..setEntry(1, 1, 1 / radius)
      ..setEntry(3, 2, -perspective)
      ..setEntry(2, 3, -radius)
      ..setEntry(3, 3, perspective * radius + 1);

    // Model matrix by first translating the object from the origin of the world
    // by radius in the z axis and then rotating against the world.
    final double rotationPointMultiplier = angle > 0 ? angle / angle.abs() : 1;
    //print('Angle: $angle');
    projection *= Matrix4.translationValues(horizontalTranslation + (rotationPointMultiplier * 300), 0, 0) *
        Matrix4.rotationY(angle) *
        Matrix4.translationValues(0, 0, radius) *
        Matrix4.translationValues(-rotationPointMultiplier * 300, 0, 0);

    return projection;
  }

  Widget _buildCard(
    RadioStation station,
    int stationIndex,
    int stationCount,
    double scrollPercent,
  ) {
    final cardScrollPercent = scrollPercent / (1 / stationCount);
    final parallax = scrollPercent - (stationIndex / widget.stations.length);

    return FractionalTranslation(
      translation: Offset(stationIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Transform(
          transform: _buildCardProjection(cardScrollPercent - stationIndex),
          child: FlipCard(
            index: stationIndex,
            station: station,
            parallaxPercent: parallax,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onPanStart,
      onHorizontalDragUpdate: _onPanUpdate,
      onHorizontalDragEnd: _onPanEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }
}
