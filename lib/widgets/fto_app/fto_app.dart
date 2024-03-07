import 'package:flutter/material.dart';
import 'package:fto_app/widgets/fto_app/home_screen.dart';

class FTOApp extends StatelessWidget {
  const FTOApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final ColorScheme colorScheme = ColorScheme.fromSeed(brightness: Brightness.light, seedColor: Colors.blueGrey);
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(brightness: MediaQuery.platformBrightnessOf(context), seedColor: Colors.blueGrey);

    return MaterialApp(
      title: 'FTO',
      theme: ThemeData(
        colorScheme: colorScheme,
        // brightness: Brightness.dark,
        // primarySwatch: Colors.blueGrey,
        // scaffoldBackgroundColor: Colors.grey.shade300,
        // colorSchemeSeed: Colors.blueGrey
      ),
      home: const HomeScreen(),
    );
  }
}
