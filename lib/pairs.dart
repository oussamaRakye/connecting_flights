import 'flight.dart';

class PairFlights {
  PairFlights(this.left, this.right) {
    price = left.price + right.price;
    destinationCode = left.flyTo;
    destinationCity = left.cityTo;
    from = left.flyFrom;
    to = right.flyTo;
  }

  final Flight left;
  final Flight right;
  late final String destinationCode;
  late final String destinationCity;
  late final String from;
  late final String to;
  late final double price;

  @override
  String toString() => 'Pair[$left, $right]';
}