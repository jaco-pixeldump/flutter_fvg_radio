// foundations
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3rd party
import 'package:screen/screen.dart';

// mine
import 'Application.dart';

///
void main() async {
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  Screen.keepOn(true);

  return runApp(
    Application('FVG radio'),
  );
}