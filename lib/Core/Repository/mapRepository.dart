import 'dart:convert';
import 'dart:core';
import 'dart:math' as Math;

import 'package:fu_uber/Core/Constants/Constants.dart';
import 'package:fu_uber/Core/Utils/LogUtils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geoc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:vector_math/vector_math.dart';

class MapRepository {
  static const TAG = "MapRepository";
  GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: Constants.mapApiKey);

  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=${Constants.anotherApiKey}";
    http.Response response = await http.get(Uri.parse(url));
    Map values = jsonDecode(response.body);
    ProjectLog.logIt(TAG, "Predictions", values.toString());
    return values["routes"][0]["overview_polyline"]["points"];
  }

  Future<PlacesAutocompleteResponse> getAutoCompleteResponse(
      String search) async {
    return await places.autocomplete(search, sessionToken: "1212121");
  }

  Future<String> getPlaceNameFromLatLng(LatLng latLng) async {
    List<Placemark> placemark = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark placemark0 = placemark[0];

    return placemark0.name! +
        ", " +
        placemark0.locality! +
        ", " +
        placemark0.country!;
  }

  Future<LatLng> getLatLngFromAddress(String address) async {
    List<geoc.Location> list = await locationFromAddress(address);
    return LatLng(list[0].latitude, list[0].longitude);
  }

  LatLng getMidPointBetween(LatLng one, LatLng two) {
    double lat1 = one.latitude;
    double lon1 = one.longitude;
    double lat2 = two.latitude;
    double lon2 = two.longitude;

    double dLon = radians(lon2 - lon1);

    //convert to radians
    lat1 = radians(lat1);
    lat2 = radians(lat2);
    lon1 = radians(lon1);

    double Bx = Math.cos(lat2) * Math.cos(dLon);
    double By = Math.cos(lat2) * Math.sin(dLon);
    double lat3 = Math.atan2(Math.sin(lat1) + Math.sin(lat2),
        Math.sqrt((Math.cos(lat1) + Bx) * (Math.cos(lat1) + Bx) + By * By));
    double lon3 = lon1 + Math.atan2(By, Math.cos(lat1) + Bx);
    return LatLng(lat3, lon3);
  }
}
