import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart'
    as permmiosnHandller;

class LocationHelper {
  static final LocationHelper _helperMethods = LocationHelper._internal();

  factory LocationHelper() {
    return _helperMethods;
  }

  LocationHelper._internal();

  Future<LocationData?> getDeviceLocation() async {
    try {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;
      LocationData locationData;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          print('Service enabeld : $serviceEnabled');
          return null;
        }
      }

      permissionGranted = await location.hasPermission();
        print('permissionGranted : $permissionGranted');
      if (permissionGranted == PermissionStatus.denied) {
        // _permissionGranted = await location.requestPermission();
        // await locperm.LocationPermissions().requestPermissions(
        //     permissionLevel: locperm.LocationPermissionLevel.locationAlways);
        permmiosnHandller.Permission.locationAlways;
      }

      locationData = await location.getLocation();


      return locationData;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
