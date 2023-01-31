import 'dart:convert';
import 'dart:math';

import 'package:connecting_flights/components/tile.dart';
import 'package:connecting_flights/flight.dart';
import 'package:connecting_flights/group_flights.dart';
import 'package:connecting_flights/pairs.dart';
import 'package:connecting_flights/querier.dart';
import 'package:connecting_flights/search_class.dart';
import 'package:flutter/material.dart';

import 'components/card.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  static const String id = 'display_screen';

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {

  bool isLoading = true;
  String message = 'Loading...';
  Search? search;
  List<Widget> cards = List.empty(growable: true);
  
  final _limit = 100;

  @override
  Widget build(BuildContext context) {
    Search? search = ModalRoute.of(context)!.settings.arguments as Search?;
    loadFlights(search);
    debugPrint(isLoading.toString());
    return Scaffold(
      body: SafeArea(
        child: isLoading ? SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: min(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.5),
                height: min(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.5),
                child: const CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              ),
              const SizedBox(height: 50),
              Text(message),
            ],
          ),
        ) : SingleChildScrollView(
          child: Column(
            children: cards,
          ),
        ),
      ),
    );
  }

  void showFlights(List<GroupFlights> groupFlightsList){
    // debugPrint(groupFlightsList.length.toString());
    cards = List.empty(growable: true);

    groupFlightsList.sort((a, b) => a.cheapestFlight!.price.compareTo(b.cheapestFlight!.price));

    for (GroupFlights groupFlights in groupFlightsList) {
      List<Widget> flights = [];
      for (PairFlights pairFlights in groupFlights){
          flights.add(
           CardP(
              color: Colors.grey[600],
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('${pairFlights.left.utcDepartureString} - ${pairFlights.left.utcArrivalString}: ${pairFlights.left.airline}'),
                       Text('${pairFlights.right.utcDepartureString} - ${pairFlights.right.utcArrivalString}: ${pairFlights.right.airline}'),

                     ],
                 ),
                 Text('${pairFlights.price.toString()}€'),
               ],
             ),
           ),
        );
      }
      Widget card =  Tile(
            child: Card(
              child: ExpansionTile(

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                          groupFlights.cityName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 25,
                          )
                      ),
                    ),
                    Text(
                        '${groupFlights.cheapestFlight?.price}€',
                    ),
                  ],
                ),

                children: flights,
              ),
            ),
          );
      cards.add(card);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> loadFlights(Search? newSearch) async {
    if (search != null){
      return;
    }

    if (newSearch != null) {
      search = newSearch;
    }

    isLoading = true;

    String from = search!.from.code;
    String date = '${search!.date.day}/${search!.date.month}/${search!.date.year}';
    String to = search!.to.code;
    TimeOfDay timeDifference = search!.time;

    final dynamic request = await HTTPQuerier.getFlights(from: from, date: date, limit: 500);
    List<Flight> flights = List.empty(growable: true);
    request['data'].forEach((flight) => flights.add(Flight(flight)));
    flights = flights.where((Flight flight) => flight.flyTo != to).toList();

    Set<String> cities = Set<String>.from(flights.map((Flight flight) => flight.flyTo).where((String city) => city != to));

    Map<String, List<Flight>> flightsFromCities = {};
    int i = 0;
    for (final String city in cities) {
      final dynamic requestSecond = await HTTPQuerier.getFlights(from: city, date: date, to: to, limit: _limit);
      final List<Flight> flights = List.empty(growable: true);
      requestSecond['data'].forEach((flight) => flights.add(Flight(flight)));
      flightsFromCities[city] = flights;
      debugPrint('${++i}/${cities.length}');
      setState(() {
        message = 'Loading $i of ${cities.length} destinations';
      });
    }

    List<PairFlights> pairs = List<PairFlights>.empty(growable: true);
    for (final Flight flight in flights) {
      debugPrint(flight.toString());
      String destination = flight.flyTo;
      for (final Flight secondFlight in flightsFromCities[destination]!) {
        DateTime timeArrival = flight.utcArrival;
        DateTime timeDeparture = secondFlight.utcDeparture;
        DateTime minTimeDeparture = timeArrival.add(Duration(hours: timeDifference.hour, minutes: timeDifference.minute));
        if (timeDeparture.isAfter(minTimeDeparture)) {
          pairs.add(PairFlights(flight, secondFlight));
        }
      }
    }

    // Group the pairs by the destination
    Map<String, GroupFlights> groupedCities = {};
    for (final PairFlights pair in pairs) {
      String destination = pair.destinationCode;
      if (groupedCities.containsKey(destination)) {
        groupedCities[destination]!.add(pair);
      } else {
        groupedCities[destination] = GroupFlights.formFlight(pair);
      }
    }

    showFlights(groupedCities.values.toList());

  }

  
}
