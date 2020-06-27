import 'package:geolocator/geolocator.dart';
import 'package:saviour/data/location.dart';

class LocationResult {
  static Future<Location> getLocationNow() async {
    Position position;

    try {
      position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      position = await Geolocator()
          .getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    }

    return Location(lat: position?.latitude, long: position?.longitude);
  }
}