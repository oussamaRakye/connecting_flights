import 'code_to_airline.dart';
class Flight {
  late final String flyFrom;
  late final String flyTo;
  late final String cityFrom;
  late final String cityTo;
  late final DateTime utcDeparture;
  late final DateTime utcArrival;
  late final String utcDepartureString;
  late final String utcArrivalString;
  late final String airline;
  late final double price;

  Flight(final dynamic flight) {
    flyFrom = flight['flyFrom'];
    flyTo = flight['flyTo'];
    cityFrom = flight['cityFrom'];
    cityTo = flight['cityTo'];
    utcDeparture = DateTime.parse(flight['route'][0]['utc_departure'].toString());
    utcArrival = DateTime.parse(flight['route'][0]['utc_arrival'].toString());
    utcDepartureString = '${timeCleaner(utcDeparture.hour)}:${timeCleaner(utcDeparture.minute)}';
    utcArrivalString = '${timeCleaner(utcArrival.hour)}:${timeCleaner(utcArrival.minute)}';
    airline = getAirline(flight['route'][0]['airline'].toString());
    price = double.parse(flight['price'].toString());
  }

  // override to string
  @override
  String toString() => 'Flight[$flyFrom, $flyTo, $cityFrom, $cityTo, $utcDeparture, $utcArrival, $price]';

  String getAirline(String code) {
    if (codeToAirline.containsKey(code)) {
      return codeToAirline[code]!;
    } else {
      return code;
    }
  }
}

String timeCleaner(int time) {
  return time.toString().length == 1 ? '0$time' : '$time';
}