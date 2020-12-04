
import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';
import 'package:google_places/src/models.dart';


class AutoCompleteRequest {

   String input;
   LocationBias locationBias;
   LatLng origin;
   String sessionToken;

   Map<String, dynamic> toMap() {
     return {
       "input" : input,
       "locationBias" : locationBias?.toMap(),
       "origin" : origin?.toMap(),
       "sessionToken" : sessionToken
     };
   }

   bool isValid() {

     if (input.isEmpty) return false;

     return true;
   }
}

class LocationBias {

  LocationBias(
    this.ne,
    this.sw
  );

  LatLng ne;
  LatLng sw;

  Map<String, Map<String, num>>toMap() {
    return {
      "ne" : ne.toMap(),
      "sw" : sw.toMap(),
    };
  }
}

class LatLng {

  LatLng(
    this.lat,
    this.lng
  );

  num lat;
  num lng;

  Map<String, num> toMap() {
    return {
      "lat" : lat,
      "lng" : lng
    };
  }
}

// https://developers.google.com/maps/documentation/javascript/reference/places-autocomplete-service#AutocompletePrediction
class GooglePlaces {
  static const MethodChannel _channel =
      const MethodChannel('google_places');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<List<AutocompletePrediction>> autocomplete(AutoCompleteRequest request) async {

    if (!request.isValid()) return Future.error("Input must be specified");

    var result =  await _channel.invokeMethod(
        'autocomplete',
        request.toMap()
    );

    List<AutocompletePrediction> predictions = [];

    if (result is List) {

      result.forEach((dynamic prediction) {
        if (prediction is Map) {
            print(prediction['distance']);
            predictions.add(AutocompletePrediction(
              fullText: prediction['fullText'],
              primaryText: prediction['primaryText'],
              secondaryText: prediction['secondaryText'],
              placeId: prediction['placeId'],
              distance: prediction['distance'],
              types: (prediction['types'] as List)?.map((e) => e as String)?.toList()
            ));
//           predictions.add(AutocompletePrediction.fromLinkedHashMap(prediction));
        }
//        print('whee');
//        if (map is Map) {
//          return AutocompletePrediction.fromMap(map);
//        }
      });
    }

    return predictions;

  }
}
