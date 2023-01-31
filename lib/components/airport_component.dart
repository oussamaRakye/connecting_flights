import 'package:connecting_flights/airport.dart';
import 'package:connecting_flights/components/text_flexible.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'card.dart';

class AirportCard extends StatelessWidget {

  final Airport airport;

  const AirportCard({Key? key, required this.airport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, airport),
      child: CardP(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFlexible(
                      airport.name,
                    style: const TextStyle(
                      fontSize: Constant.selectTextSize,
                    ),
                  ),
                  Text(
                      airport.country,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1,child: Align(alignment: Alignment.centerRight,child: Text(airport.code))),
          ],
        ),
      ),
    );
  }
}
