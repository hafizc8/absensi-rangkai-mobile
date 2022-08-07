import 'package:absensi_rangkai_mobile/app/modules/error_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:safe_device/safe_device.dart';

class LocationProvider {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool isEnable = await recursiveRequestLocation();

    print("isEnable gps: $isEnable");
    if (!isEnable) {
      return determinePosition();
    }

    return Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromCoordinate(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);

    if (placemarks.isNotEmpty) {
      print(placemarks.toString());
      String address = 
        placemarks[0].street.toString() + ", " + 
        placemarks[0].subLocality.toString() + ", " + 
        placemarks[0].locality.toString() + ", " + 
        placemarks[0].subAdministrativeArea.toString();
        
      return address;
    }

    return "Tidak mendapatkan alamat";
  }

  Future<bool> recursiveRequestLocation() async {
    bool _serviceEnabled;
    loc.Location location = loc.Location();
    LocationPermission permission;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
          }
        }
        
        if (permission == LocationPermission.deniedForever) {
          return Future.error('Location permissions are permanently denied, we cannot request permissions.');
        }
        return recursiveRequestLocation();
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
