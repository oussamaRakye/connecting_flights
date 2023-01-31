import 'package:connecting_flights/airport.dart';
import 'package:connecting_flights/flight_selector.dart';
import 'package:flutter/material.dart';
import 'package:connecting_flights/search_screen.dart';
import 'package:connecting_flights/constants.dart';

class PlaceSelector extends StatefulWidget {

  final String message;
  final String hint;
  FlightSelectorScreenState parentState;
  Airport? airport;

  PlaceSelector({Key? key, required this.message, required this.hint, required this.parentState}) : super(key: key);

  @override
  State<PlaceSelector> createState() => _PlaceSelectorState();
}

class _PlaceSelectorState extends State<PlaceSelector> {


  Future<void> openSearch(BuildContext context) async {
    await Navigator.pushNamed(context, SearchScreen.id).then((value) => widget.airport = value == null ? widget.airport : (value as Airport));
    setState(() {
    });
    widget.parentState.setState(() {
      widget.parentState.areLocSelected = widget.parentState.fromSelector!.airport != null && widget.parentState.toSelector!.airport != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openSearch(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(widget.message),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.airport == null ? Text(
                    widget.hint,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: Constant.selectTextSize,
                      color: Colors.grey,
                    ),

                ) : Text(
                    widget.airport!.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      fontSize: Constant.selectTextSize,
                      color: Constant.darkBlue,
                    ),
                ),
                widget.airport == null ? const Text('') : Text(
                    widget.airport!.code,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: Constant.selectTextSize,
                    color: Constant.darkBlue,
                  ),
                ),
              ],
            ),
      ]
      ),
    );
  }
}

