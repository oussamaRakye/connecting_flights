import 'package:connecting_flights/components/tile.dart';
import 'package:flutter/material.dart';

class CardP extends StatelessWidget {
  final Widget child;
  final Color? color;
  const CardP({Key? key, required this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tile(
      child: Card(
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: child,
        ),
      )
    );
  }
}
