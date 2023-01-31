import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HTTPQuerier {
  static const locationUrl = 'https://tequila-api.kiwi.com/locations/query?';
  static const flightUrl = 'https://tequila-api.kiwi.com/v2/search?';


  static String getLocationQueryBuilder(String location){
    var params = {
      'term': location,
      'locale': 'en-US',
      'location_types': 'airport',
      'limit': '10',
      'active_only': 'true'
    };
    String paramsString = '';

    params.forEach((key, value) {
      paramsString += '$key=$value&';
    });

    return locationUrl + paramsString;
  }

  static Future<dynamic> getLocation(String location) async {
    final response = await http.get(
      Uri.parse(getLocationQueryBuilder(location)),
      headers: {
        'accept': 'application/json',
        'apikey': 'PIPrZO3MzYC-Ksr9lAk-AKl8exhnpQXP',
      },
    );
    return json.decode(response.body);
  }

  static String getFlightsQueryBuilder(String from, String date, String? to, int limit){
    var params = {
      'fly_from': from,
      'date_from': date,
      'date_to': date,
      'limit': limit,
      'curr': 'EUR',
      'max_stopovers': '0',
    };
    if(to != null){
      params['fly_to'] = to;
    }
    String paramsString = '';

    params.forEach((key, value) {
      paramsString += '$key=$value&';
    });

    return flightUrl + paramsString;
  }

  static Future<dynamic> getFlights({required String from, required String date, String? to, int limit = 5}) async {
    final response = await http.get(
      Uri.parse(getFlightsQueryBuilder(from, date, to, limit)),
      headers: {
        'accept': 'application/json',
        'apikey': 'PIPrZO3MzYC-Ksr9lAk-AKl8exhnpQXP',
      },
    );
    return json.decode(response.body);
  }
}
