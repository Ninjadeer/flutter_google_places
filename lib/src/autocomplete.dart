@JS() // sets the context, in this case being `window`
library main;

import 'package:js/js.dart'; // Pull in our dependency

@JS("google.maps.places.AutocompleteService")
class AutocompleteService {

  /// Executes the request and runs the supplied callback on response.
  external void getQueryPredictions(
      QueryAutocompletionRequest queryAutocompletionRequest,
      Function callback
  );
}

@JS()
@anonymous
class QueryAutocompletionRequest {

  dynamic input;
  LatLngBounds bounds;
  LatLng location;
  LatLng origin;
  List<String> types;
}

@JS("google.maps.LatLngBounds")
class LatLngBounds {
  external LatLngBounds(LatLng sw, LatLng ne);
}

@JS("google.maps.LatLng")
class LatLng {
  external LatLng(num lat, num lng);
}
