import 'package:connecting_flights/airport.dart';
import 'package:connecting_flights/components/airport_component.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'querier.dart';

class SearchScreen extends StatefulWidget {
  
  const SearchScreen({Key? key}) : super(key: key);

  static const String id = 'search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<AirportCard> airports = List<AirportCard>.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              onChanged: (input) => setState(() {
                updateAirports(input);
              }),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(),
                labelText: 'Enter the place',
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: airports,),
              ),
            ),
          ],
        ),
      ),
    );
  }



  updateAirports(String input) async {
    if (input.isEmpty) {
      airports = List.empty(growable: true);
      return;
    }
    final dynamic result = await HTTPQuerier.getLocation(input);
    airports = List.empty(growable: true);
    for (final dynamic airport in result['locations']) {
      String code = airport['code'];
      String name = airport['name'];
      String country = airport['city']['country']['name'];
      airports.add(AirportCard(airport: Airport(name: name, country: country, code: code)));
    }
  }
}
