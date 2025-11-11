import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';

//stateful porque va cambiando el estado, por el map controles y por el marcador q la persona mueve, va cambiando segun lo que pone el usuario
class SelectorUbicacionScreen extends StatefulWidget {
  final LatLng ubicacionInicial;

  const SelectorUbicacionScreen({super.key, required this.ubicacionInicial}); //necesita la ubicación inicial

  @override
  State<SelectorUbicacionScreen> createState() => _SelectorUbicacionScreenState();
}

class _SelectorUbicacionScreenState extends State<SelectorUbicacionScreen> {
  late MapController _mapController; //controlador del mapa para que lo meuva etc
  late LatLng _ubicacionSeleccionada; //ubicacion que elija con el marcador
  //late porque dependen de cosas del widget no creado, entonces por eso solo las declaro pero las inicializo recién en el init state

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _ubicacionSeleccionada = widget.ubicacionInicial; //primero agarra la que le pasé
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( //cuadrado de arriba
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton( //fecha para irse
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A949A), size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Elegir ubicación',
          style: GoogleFonts.rubik(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Text(
                  'Tocá el mapa para mover el marcador y elegir el lugar exacto del sitio que querés subir.',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: FlutterMap( //muestra el mapa
                  mapController: _mapController, //controlador
                  options: MapOptions(
                    initialCenter: _ubicacionSeleccionada, //empieza con la pasada que es la actual del usuario en teoría
                    initialZoom: 16,
                    onTap: (tapPos, latlng) { //tapPos viene con flutter map, para guardar la posicion de toque  en el mapa
                      setState(() {
                        _ubicacionSeleccionada = latlng; //guardo
                      });
                    },
                  ),
                  children: [
                    TileLayer(//para renderizar
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.anda_tranqui',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _ubicacionSeleccionada, //se ubica en la ubicacion seleccionada que se va a ctualizar con cada toque en el mapa
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_on, size: 40, color: Color(0xFFE57373)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          //boton de confirmar 
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF4A949A)),
              label: Text(
                "Confirmar ubicación",
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5F2F3),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Color(0xFF4A949A), width: 1),
              ),
              onPressed: () {
                Navigator.pop(context, _ubicacionSeleccionada); //al apretarlo vuelve a la pagina de subida, pasando la nueva ubicacón, ¿debería tener alerta? no lo se 
              },
            ),
          ),
        ],
      ),
    );
  }
}
