import 'package:flutter/material.dart';
import 'package:alzheimer_app1/models/location_data.dart';

class LocationProvider with ChangeNotifier {
  LocationData? _locationData;

  LocationData? get locationData => _locationData;

  void updateLocation(LocationData locationData) {
    _locationData = locationData;
    notifyListeners();
  }
}
