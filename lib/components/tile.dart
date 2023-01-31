import 'package:flutter/material.dart';

class Tile extends StatelessWidget {

  final Widget child;

  const Tile({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: child,
      ),
    );
  }
}
