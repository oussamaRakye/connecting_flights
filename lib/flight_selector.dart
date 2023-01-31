import 'package:connecting_flights/components/card.dart';
import 'package:connecting_flights/components/place_selector.dart';
import 'package:connecting_flights/components/tile.dart';
import 'package:connecting_flights/search_class.dart';
import 'package:connecting_flights/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'display_screen.dart';
import 'main.dart';

class FlightSelectorScreen extends StatefulWidget {
  FlightSelectorScreen({Key? key}) : super(key: key);

  static const String id = 'flight_selector_screen';

  @override
  FlightSelectorScreenState createState() => FlightSelectorScreenState();
}

class FlightSelectorScreenState extends State<FlightSelectorScreen> {

  DateTime? dateDeparture;
  TimeOfDay? timeDifference;

  final Map<int, String> _months = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  bool areLocSelected = false;

  PlaceSelector? fromSelector;
  PlaceSelector? toSelector;

  @override
  initState() {
    super.initState();
    fromSelector = PlaceSelector(
      message: 'From',
      hint: 'Where from?',
      parentState: this,
    );

    toSelector = PlaceSelector(
      message: 'To',
      hint: 'Where to?',
      parentState: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardP(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fromSelector!,
                    const Divider(
                      color: Colors.white,
                    ),
                    toSelector!,
                  ],
                ),
            ),
            CardP(
                child: InkWell(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365))
                    );
                    dateDeparture = selectedDate ?? dateDeparture;
                    setState(() {});
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Text('Fly out'),
                      ),
                      dateDeparture == null ? const Text(
                          'Select date',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: Constant.selectTextSize,
                          color: Colors.grey,
                        ),
                      ) : Text(
                          '${dateDeparture?.day} ${_months[dateDeparture?.month]} ${dateDeparture?.year}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Constant.selectTextSize,
                          color: Constant.darkBlue,
                        ),
                      ),
                    ],
                  ),
                )
            ),
            CardP(
                child: InkWell(
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 8, minute: 0)
                    );
                    timeDifference = selectedTime ?? timeDifference;
                    setState(() {});
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: Text('Time difference between flights'),
                      ),
                      timeDifference == null ? const Text(
                        'Select time',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: Constant.selectTextSize,
                          color: Colors.grey,
                        ),
                      ) : Text(
                        '${timeCleaner(timeDifference!.hour)}:${timeCleaner(timeDifference!.minute)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Constant.selectTextSize,
                          color: Constant.darkBlue,
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Tile(
              child: ElevatedButton(
                onPressed: dateDeparture == null || timeDifference == null || !areLocSelected ? null : () {
                  Navigator.pushNamed(context, DisplayScreen.id, arguments: Search(
                    from: fromSelector!.airport!,
                    to: toSelector!.airport!,
                    date: dateDeparture!,
                    time: timeDifference!,
                  ));
                },
                child: const Icon(Icons.flight_takeoff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String timeCleaner(int time) {
  return time.toString().length == 1 ? '0$time' : '$time';
}



