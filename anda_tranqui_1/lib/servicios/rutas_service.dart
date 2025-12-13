import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/foundation.dart';

class RutasService {
  Future<List<LatLng>> obtenerRuta(LatLng origen, LatLng destino) async {
    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/${origen.longitude},${origen.latitude};${destino.longitude},${destino.latitude}?overview=full&geometries=polyline',
    );
    
    final response = await http.get(url);
    if (response.statusCode != 200) throw Exception('Error al obtener ruta');

    final data = json.decode(response.body);
    final geometry = data['routes'][0]['geometry'] as String;

    // ✅ IMPORTANTE: especificar tipos explícitamente <String, List<LatLng>>
    return compute<String, List<LatLng>>(_decodificarPolyline, geometry);
  }
}

// Función top-level para usar con compute
List<LatLng> _decodificarPolyline(String geometry) {
  return PolylinePoints()
      .decodePolyline(geometry)
      .map((p) => LatLng(p.latitude, p.longitude))
      .toList();
}