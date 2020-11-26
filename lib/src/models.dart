import 'dart:collection';

class AutocompletePrediction {

  AutocompletePrediction({
    this.fullText,
    this.primaryText,
    this.secondaryText,
    this.placeId,
    this.distance,
    this.types
  });

  num distance;
  String placeId;
  String fullText;
  String primaryText;
  String secondaryText;
  List<String> types;

  @override
  String toString() {
    return {
      'placeId' : placeId,
      'fullText' : fullText,
      'primaryText' : primaryText,
      'secondaryText' : secondaryText,
      'distance' : distance,
      'types' : types
    }.toString();
  }
}
