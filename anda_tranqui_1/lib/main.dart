import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'ui/pantallas/openstreetmap.dart';
import 'ui/pantallas/subir_sitio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 

  await Supabase.initialize(
    url: 'https://hqlcitdxmxjwmodyvihh.supabase.co',     
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbGNpdGR4bXhqd21vZHl2aWhoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI2MjI1NzQsImV4cCI6MjA2ODE5ODU3NH0.XSWI6LzDgc07VIhyBARpm3rJMBnxMhQVz5pgMUB-id8',              
  );
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
