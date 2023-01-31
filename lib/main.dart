import 'package:connecting_flights/display_screen.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'flight_selector.dart';
import 'search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Constant.darkBlue,
        ),
      ),
      initialRoute: FlightSelectorScreen.id,
      routes: {
        FlightSelectorScreen.id: (context) => FlightSelectorScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        DisplayScreen.id: (context) => const DisplayScreen(),
      },
    );
  }
}

