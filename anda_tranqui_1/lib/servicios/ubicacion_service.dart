import 'package:location/location.dart';


class UbicacionService {
  final Location _location = Location();

  Future<bool> verificarPermisos() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }
    var permission = await _location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
      if (permission != PermissionStatus.granted) return false;
    }
    return true;
  }

  Stream<LocationData> obtenerUbicacion() {
    return _location.onLocationChanged;
  }
}
