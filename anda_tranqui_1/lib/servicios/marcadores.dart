import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<Marker> generarMarcadores({
  
  required List<Map<String, dynamic>> sitios,
  required Function(LatLng) onMarkerTap,
  required Function(Map<String, dynamic>) onTapSitio,
}) {
  return sitios.map((sitio) {
    final lat = sitio['latitud'];
    final lng = sitio['longitud'];
    final tipoSitio = sitio['id_tipo_sitio']; // 1 = baño, 2 = agua

    Color colorMarcador;
    if (tipoSitio == 1) {
      colorMarcador = Color(0xFF187BA2); //  azul para baño
    } else if (tipoSitio == 2) {
      colorMarcador = Color(0xFF7DAD93); // verde para agua
    } else {
      colorMarcador = Colors.red; // por defecto si no se reconoce
    }

    return Marker(
      width: 40,
      height: 40,
      point: LatLng(lat, lng),
      child: GestureDetector(
        onTap: () {
          onMarkerTap(LatLng(lat, lng));
          onTapSitio(sitio);
        },
        child: Icon(Icons.place, color: colorMarcador, size: 40),
      ),
    );
  }).toList();
}
