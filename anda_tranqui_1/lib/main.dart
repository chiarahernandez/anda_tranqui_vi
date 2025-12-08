import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'ui/pantallas/openstreetmap.dart';
import 'ui/pantallas/subir_sitio.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/subirSitio': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as LatLng;
          return SubirSitioScreen(ubicacion: args);
        },
      },
      home: const OpenstreetmapScreen(), 
    );
  }
}