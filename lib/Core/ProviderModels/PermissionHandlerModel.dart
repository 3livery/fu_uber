import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class PermissionHandlerModel extends ChangeNotifier {
  Location location = Location();

  PermissionStatus isLocationPerGiven = PermissionStatus.denied;
  PermissionStatus isLocationSerGiven = PermissionStatus.denied;

  PermissionHandlerModel() {
    location.changeSettings(accuracy: LocationAccuracy.low);
    location.hasPermission().then((isGiven) {
      if (isGiven == PermissionStatus.granted) {
        isLocationPerGiven = PermissionStatus.granted;
        location.serviceEnabled().then((isEnabled) {
          if (isEnabled) {
            isLocationSerGiven = PermissionStatus.granted;
          } else {
            isLocationSerGiven = PermissionStatus.denied;
          }
          notifyListeners();
        });
      } else {
        isLocationPerGiven = PermissionStatus.denied;
      }
      notifyListeners();
    });
  }

  Future<bool> checkAppLocationGranted() async {
    return await location.hasPermission() == PermissionStatus.granted;
  }

  requestAppLocationPermission() {
    location.requestPermission().then((isGiven) {
      isLocationPerGiven = isGiven;
      notifyListeners();
    });
  }

  Future<bool> checkLocationServiceEnabled() {
    return location.serviceEnabled();
  }

  requestLocationServiceToEnable() {
    location.requestService().then((isGiven) {
      isLocationSerGiven = isGiven ? PermissionStatus.granted : PermissionStatus.denied;
      notifyListeners();
    });
  }
}
