import 'package:connecting_flights/pairs.dart';

import 'flight.dart';

class GroupFlights extends Iterable<PairFlights> {
  List<PairFlights> flights = [];
  PairFlights? cheapestFlight;
  late final String cityCode;
  late final String cityName;

  GroupFlights(this.cityCode, this.cityName);

  GroupFlights.formFlight(PairFlights flightPair){
    cityCode = flightPair.destinationCode;
    cityName = flightPair.destinationCity;
    add(flightPair);
  }

  void add(PairFlights flightPair) {
    flights.add(flightPair);
    flights.sort((a, b) => a.price.compareTo(b.price));

    if (cheapestFlight == null || cheapestFlight!.price > flightPair.price) {
      cheapestFlight = flightPair;
    }
  }

  @override
  Iterator<PairFlights> get iterator => flights.iterator;
}