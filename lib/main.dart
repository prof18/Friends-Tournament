import 'package:flutter/material.dart';
import 'package:friends_tournament/src/bloc/setup_bloc_provider.dart';
import 'package:friends_tournament/src/views/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SetupBlocProvider(
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Welcome()),
    );
  }
}
