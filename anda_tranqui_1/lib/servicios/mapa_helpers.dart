import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// Calcula la distancia entre dos coordenadas y la devuelve como texto legible.
String calcularDistancia(LatLng origen, LatLng destino) {
  final Distance distance = const Distance();
  final metros = distance.as(LengthUnit.Meter, origen, destino);

  if (metros < 1000) {
    return '${metros.toStringAsFixed(0)} m';
  } else {
    final km = (metros / 1000).toStringAsFixed(2);
    return '$km km';
  }
}

/// Devuelve un color asociado al tipo de sitio para usar en rutas o marcadores.
Color obtenerColorRuta(int? tipo) {
  switch (tipo) {
    case 1:
      return const Color(0xFF187BA2); //  Baño
    case 2:
      return const Color(0xFF7DAD93); //  Agua
    default:
      return const Color.fromARGB(255, 243, 33, 79); // Otro
  }
}
