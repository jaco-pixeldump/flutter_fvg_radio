// foundations
import 'package:flutter/material.dart';

// 3rd party
import 'package:provider/provider.dart';

// mine
import 'package:fvg_radio/core/RadioBloc.dart';
import 'package:fvg_radio/ui/HomeView.dart';

class Application extends StatelessWidget {
  final title;

  Application(this.title);

  @override
  Widget build(BuildContext context) {
    return Provider<RadioBloc>(
      builder: (_) => RadioBloc(),
      dispose: (_, value) => value.dispose(),
      child: MaterialApp(
        title: title,
        home: HomeView(),
      ),
    );
  }
}
