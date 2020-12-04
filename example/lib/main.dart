import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_places/google_places.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: TextFormField(
          onChanged: (String input) async {

            // TODO generate token;

            var request = AutoCompleteRequest();

            request.input = input;
            request.locationBias = LocationBias(
              LatLng(-33.8749937, 151.2041382),
              LatLng(-33.8749937, 151.2041382),
            );

            request.origin = LatLng(-33.8749937, 151.2041382);

            request.sessionToken = "0f95cc9b-9e8e-49cf-b85e-8cd639bdbc16";

            var bar = await GooglePlaces.autocomplete(request);

            print(bar);

//            queryAutocompletionRequest.input = 'Tramshed';
//            queryAutocompletionRequest.origin = LatLng(-33.8749937, 151.2041382);
//            queryAutocompletionRequest.bounds = LatLngBounds(
//                LatLng(-33.8749937, 151.2041382),
//                LatLng(-33.8749937, 151.2041382)
//            );
//            queryAutocompletionRequest.types =["establishment"];
//

          },
        ),
      ),
    );
  }
}
