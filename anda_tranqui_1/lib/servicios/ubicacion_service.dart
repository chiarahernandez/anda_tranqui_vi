import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class UbicacionService {
  final Location _location = Location();

  Future<bool> verificarPermisos() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // 1. Intentar verificar si el servicio está activo
    try {
      serviceEnabled = await _location.serviceEnabled();
    } on Exception catch (e) {
      debugPrint('Error verificando servicio: $e');
      // Si falla la verificación, asumimos que está apagado o falló, 
      // pero dejamos que el requestService intente activarlo.
      serviceEnabled = false; 
    }

    if (!serviceEnabled) {
      try {
        serviceEnabled = await _location.requestService();
      } on Exception catch (e) {
        debugPrint('Error solicitando servicio: $e');
        return false;
      }
      if (!serviceEnabled) {
        return false;
      }
    }

    // 2. Verificar Permisos de la App
    try {
      permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return false;
        }
      }
    } on Exception catch (e) {
      debugPrint('Error con permisos: $e');
      return false;
    }

    // 3. Configuración para "despertar" el GPS (Importante para que cargue rápido)
    try {
      await _location.changeSettings(
        accuracy: LocationAccuracy.high, // Alta precisión
        interval: 5000, // Actualizar cada 5 segs
        distanceFilter: 10, // O cada 10 metros
      );
    } catch (e) {
       // Ignoramos si esto falla, no es crítico
       debugPrint('No se pudo configurar settings: $e');
    }

    return true;
  }

  // Obtener una sola vez la ubicación (útil para el inicio)
  Future<LocationData?> obtenerUbicacion() async {
    try {
      return await _location.getLocation();
    } catch (e) {
      debugPrint('Error obteniendo ubicación única: $e');
      return null;
    }
  }

  // Stream para movimiento continuo
  Stream<LocationData> obtenerUbicacionStream() {
    return _location.onLocationChanged;
  }
}