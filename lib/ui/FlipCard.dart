// foundations

import 'package:flutter/material.dart';

// 3rd party

// mine
import 'package:fvg_radio/core/RadioStation.dart';

///
class FlipCard extends StatelessWidget {
  final int index;
  final RadioStation station;
  final double parallaxPercent; // [0.0, 1.0] (0.0 for all the way right, 1.0 for all the way left)

  FlipCard({
    this.index,
    this.station,
    this.parallaxPercent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Background
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            child: FractionalTranslation(
              translation: Offset(parallaxPercent * 2, 0),
              child: OverflowBox(
                maxWidth: double.infinity,
                child: Image.asset(
                  station.backgroundPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

        // Content
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '.${index + 1} ',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, .4),
                    fontSize: 80,
                    fontFamily: 'petita',
                    letterSpacing: -5,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 50),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  color: Colors.black.withOpacity(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        station.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'petita',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
