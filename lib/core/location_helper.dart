import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as locperm;
import 'package:permission_handler/permission_handler.dart'
    as permissionhandler;

class LocationHelper {
  static final LocationHelper _helperMethods = LocationHelper._internal();

  factory LocationHelper() {
    return _helperMethods;
  }

  LocationHelper._internal();

  openAppSettingToEnable() async {
    permissionhandler.openAppSettings();
    // permissionhandler.PermissionStatus locStatus =
    //     await permissionhandler.Permission.location.request();
    // print("Location status : $locStatus");
  }

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
        locperm.PermissionStatus permissionStatus =
            await locperm.LocationPermissions().requestPermissions(
                permissionLevel: locperm.LocationPermissionLevel.location);
        // print(permissionStatus.name);
        // if (PermissionStatus.denied.name == permissionStatus.name) {
        //   permmisionHandller.openAppSettings();
        // }

        //  permmisionHandller.openAppSettings();
      }

      locationData = await location.getLocation();

      return locationData;
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }
}
