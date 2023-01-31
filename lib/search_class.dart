import 'package:connecting_flights/airport.dart';
import 'package:flutter/material.dart';

class Search {
  final Airport from;
  final Airport to;
  final DateTime date;
  final TimeOfDay time;

  Search({required this.from, required this.to, required this.date, required this.time});
}