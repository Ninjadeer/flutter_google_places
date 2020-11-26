import 'dart:async';
// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:js';

import 'src/autocomplete.dart';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A web implementation of the GooglePlaces plugin.
class GooglePlacesWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'google_places',
      const StandardMethodCodec(),
      registrar.messenger,
    );

    final pluginInstance = GooglePlacesWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
        break;
      case 'autocomplete':

        var request = QueryAutocompletionRequest();

        request.input = call.arguments['input'];

        request.bounds = call.arguments['locationBias'] != null ? LatLngBounds(
          LatLng(
            call.arguments['locationBias']['sw']['lat'],
            call.arguments['locationBias']['sw']['lng']
          ),
          LatLng(
              call.arguments['locationBias']['sw']['lat'],
              call.arguments['locationBias']['sw']['lng']
          )
        ) : null;

        request.origin = call.arguments['origin'] != null ? LatLng(
            call.arguments['origin']['lat'],
            call.arguments['origin']['lng']
        ) : null;

        request.types = call.arguments['types'];

        return autocomplete(request);
        break;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'google_places for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }

  Future<List<dynamic>> autocomplete(QueryAutocompletionRequest request) {

    Completer<List<dynamic>> _completer = Completer();

    var autoCompleteService = AutocompleteService();

    List<dynamic> results = [];

    Function autocompleteCallback = (List<dynamic> predictions, String status) {

      predictions.forEach((element) {
        results.add({
          'fullText' : element.description,
          'primaryText' : element.structured_formatting.main_text,
          'secondaryText' : element.structured_formatting.secondary_text,
          'placeId': element.place_id,
          'types' : element.types,
          'distance' : element.distance_meters
        });
      });

      _completer.complete(results);
    };

    autoCompleteService.getQueryPredictions(request, allowInterop(autocompleteCallback));

    return _completer.future;

  }
}

