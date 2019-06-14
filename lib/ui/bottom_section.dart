// foundations
import 'package:flutter/material.dart';

class BottomSection extends StatelessWidget {
  final int itemCount;
  final double scrollPercent;

  BottomSection({
    this.itemCount,
    this.scrollPercent,
      }){
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 32, right: 32, top: 0, bottom: 0),
                child: Center(
                  child: Container(
                    height: 5.0,
                    child: ScrollIndicator(
                      itemCount: itemCount,
                      scrollPercent: scrollPercent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final int itemCount;
  final double scrollPercent;

  ScrollIndicator({
    this.itemCount,
    this.scrollPercent,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
        itemCount: itemCount,
        scrollPercent: scrollPercent,
      ),
      child: Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int itemCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({
    this.itemCount,
    this.scrollPercent,
  })  : trackPaint = Paint()
          ..color = const Color(0xFF444444)
          ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw track
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: Radius.circular(3),
        topRight: Radius.circular(3),
        bottomLeft: Radius.circular(3),
        bottomRight: Radius.circular(3),
      ),
      trackPaint,
    );

    // Draw thumb
    final thumbWidth = size.width / itemCount;
    final thumbLeft = scrollPercent * size.width;

    Path thumbPath = Path();
    thumbPath.addRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          thumbLeft,
          0,
          thumbWidth,
          size.height,
        ),
        topLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0),
      ),
    );

    // Thumb shape
    canvas.drawPath(
      thumbPath,
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
