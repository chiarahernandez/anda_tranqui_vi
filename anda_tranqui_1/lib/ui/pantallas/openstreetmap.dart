import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/boton_subir.dart';
import '../widgets/boton_filtros.dart';
import '../widgets/boton_busqueda.dart';
import '../widgets/boton_centrar.dart';
import '../../servicios/api_service.dart';
import '../../servicios/log_etiquetas.dart';
import '../../servicios/ubicacion_service.dart';
import '../../servicios/rutas_service.dart';
import 'package:anda_tranqui/servicios/marcadores.dart';
import 'package:anda_tranqui/ui/widgets/seccion_sitio/seccion_intermedia.dart';
import '../widgets/buscador.dart';
import '../../servicios/mapa_helpers.dart';


class OpenstreetmapScreen extends StatefulWidget {
  const OpenstreetmapScreen({super.key});

  @override
  State<OpenstreetmapScreen> createState() => _OpenstreetmapScreenState();
}

// Esta clase maneja el estado de la pantalla OpenstreetmapScreen
class _OpenstreetmapScreenState extends State<OpenstreetmapScreen> {
  final MapController _mapController = MapController();
  final UbicacionService _ubicacionService = UbicacionService();
  bool isLoading = true;
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> _route = [];
  Map<String, dynamic>? _sitioSeleccionado;
  List<EtiquetaData>? _etiquetas;
  List<Map<String, dynamic>> _sitios = [];
  int? _tipoRutaDestino; // 1 = baño, 2 = agua potable
  int? _filtroSeleccionado; // null = todos, 1 = baños, 2 = agua

  bool _mostrarBuscador = false; //esto es para si apreto la lupa o no
  TextEditingController _searchController = TextEditingController(); // Controlador para el buscador
  List<Map<String, dynamic>> _sugerencias = []; //es la lista de sugerencias al buscar según lo qeu ingreses

  // Inicializa el estado de la pantalla
  @override
  void initState() {
    super.initState();

    _initializelocation();
    fetchSitios();
    
    //listener escucha cuando el usuario escribe algo 
  _searchController.addListener(() {
    final texto = _searchController.text.toLowerCase(); //agarra el texto
      setState(() {
        _sugerencias = _sitios.where((sitio) {  //recorre sitios
          final nombre = (sitio['nombre'] ?? '').toString().toLowerCase(); //agarra nombre
          return nombre.contains(texto); //devuelve solo los que contengan el texto en nombre, guarda en sugerencias
        }).toList(); //lo hace lista
      });
    });

  }

  @override
  void dispose() {
     _searchController.dispose();
    super.dispose();
  }

  // Obtiene los sitios mínimos(id, lon, lat y tipo) desde la API y los almacena en el estado
  Future<void> fetchSitios() async {
    final api = ApiService();
    try {
      final sitios = await api.obtenerSitios();
      print('Sitios cargados: $_sitios');
      setState(() {
        _sitios = sitios;
        
      });
    } catch (e) {
      errorMessage('No se pudo obtener los sitios.');
    }
  }

  // Inicializa la ubicación actual del usuario y comienza a escuchar cambios en la ubicación
  Future<void> _initializelocation() async {
    final tienePermisos = await _ubicacionService.verificarPermisos();
    if (!tienePermisos) return;

    _ubicacionService.obtenerUbicacion().listen((locationData) {
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation = LatLng(
            locationData.latitude!,
            locationData.longitude!,
          );
          isLoading = false;
        });
      }
    });
  }

  // Mueve el mapa a la ubicación actual del usuario
  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener la ubicación actual'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
    
  //recupera la info de un sitio para pasarle a la sección
  Future<void> _cargarInfoSitioCompleta(
    int idSitio,
    double lat,
    double lng,
    int idTipoSitio, // Agregado para identificar el tipo de sitio
  ) async {
    final api = ApiService();
    final sitio = await api.obtenerInfoSitioPorId(idSitio);

    if (sitio != null) {
      final etiquetas = generarEtiquetas(
        gratis: sitio['gratis'] == 1,
        adaptable: sitio['adaptable'] == 1,
        limpiezaTexto: sitio['limpieza'] ?? 'Sin datos',
      );
      final distancia =
          (_currentLocation != null)
              ? calcularDistancia(_currentLocation!, LatLng(lat, lng))
              : 'Desconocida';

      setState(() {
        _sitioSeleccionado = {
          ...sitio,
          'latitud': lat,
          'longitud': lng,
          'distancia': distancia,
          'id_tipo_sitio':
              idTipoSitio, // Agregado para identificar el tipo de sitio
        };
        _etiquetas = etiquetas;
      });
    } else {
      errorMessage('No se pudo obtener la información del sitio.');
    }
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null || _destination == null) return;

    try {
      final rutasService = RutasService();
      final ruta = await rutasService.obtenerRuta(
        _currentLocation!,
        _destination!,
      );
      setState(() {
        _route = ruta;
      });
    } catch (e) {
      errorMessage('Error al obtener la ruta');
    }
  }

  void errorMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading // Muestra un indicador de carga mientras se obtiene la ubicación
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                mapController: _mapController, // Controlador del mapa
                options: MapOptions(
                  initialCenter: _currentLocation ??
                      LatLng(-32.8894, -68.8458),
                  initialZoom: 15.0,
                  onTap: (tapPosition, point) {
                    setState(() => _sitioSeleccionado = null); //que si toca afuera se vaya, unica forma de sacar el sheet
                  },
                ),
                children: [
                  TileLayer(
                    //capa de tiles, para renderizar
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.anda_tranqui',
                  ),
                  CurrentLocationLayer(
                    // Capa que muestra la ubicación actual del usuario
                    style: LocationMarkerStyle(
                      marker: const DefaultLocationMarker(
                        child: Icon(
                          Icons.location_pin,
                          color: Color.fromARGB(255, 185, 214, 220),
                        ),
                      ),
                      markerSize: const Size(35, 35),
                      markerDirection:
                          MarkerDirection
                              .heading, // Orienta el marcador según la dirección del movimiento, wtf ni sabia q pasaba
                    ),
                  ),
                  MarkerLayer(
                    markers: generarMarcadores(
                      sitios: _sitios.where((sitio) {
                        if (_filtroSeleccionado == null) return true;
                        return sitio['id_tipo_sitio'] == _filtroSeleccionado;
                      }).toList(),
                      onMarkerTap: (LatLng destino) {
                        setState(() {
                          _destination = destino;
                        });
                        _fetchRoute();
                      },
                      onTapSitio: (sitio) {
                        final int idSitio = sitio['id_sitio'];
                        final double lat = sitio['latitud'];
                        final double lng = sitio['longitud'];
                        final int idTipoSitio = sitio['id_tipo_sitio'];

                        setState(() {
                          _tipoRutaDestino = sitio['id_tipo_sitio'];
                        });

                        _cargarInfoSitioCompleta(
                          idSitio,
                          lat,
                          lng,
                          idTipoSitio,
                        );
                      },
                    ),
                  ),
                  if (_currentLocation != null &&
                      _destination != null &&
                      _route.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _route,
                          strokeWidth: 5.0,
                          color: obtenerColorRuta(_tipoRutaDestino),
                        ),
                      ],
                    ),
                ],
              ),
              //filtros
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(child: BotonFiltros(
              filtroActual: _filtroSeleccionado,
              onSeleccionar: (nuevoFiltro) { //cuando la persona toca un filtro se cambia el estado
                setState(() { 
                  _filtroSeleccionado = nuevoFiltro;
                });
              },
            ),
            ),
          ),
          //buscador
          Positioned(
            top: 100,
            left: 30,
            right: 30,
            child: _mostrarBuscador  //si la persona apretó
              ? Buscador(
                  controller: _searchController, //usa el que tengo escuchando
                  sugerencias: _sugerencias, //usa las sugerencias que tengo
                  onSeleccionar: (sitio) { //si elige una agarra sus datos
                    final lat = sitio['latitud'];
                    final lng = sitio['longitud'];
                    final idSitio = sitio['id_sitio'];
                    final tipo = sitio['id_tipo_sitio'];

                    _mapController.move(LatLng(lat, lng), 16.0); //mueve el mapa
                    _cargarInfoSitioCompleta(idSitio, lat, lng, tipo); //usa la vista

                    setState(() { //cambia el estado, saca el buscador, limpia sugerencias y buscador
                      _mostrarBuscador = false;
                      _sugerencias = [];
                      _searchController.clear();
                    });
                  },
                  onCerrar: () { //si cierra el buscador limpia todo y muestra la lupa
                    setState(() {
                      _searchController.clear();
                      _mostrarBuscador = false;
                      _sugerencias = [];
                    });
                  },
                )
              : Align( //si no lo apretó muestra el boton de lupa
                  alignment: Alignment.centerRight,
                  child: BotonBusqueda(
                    onPressed: () { //si lo apreta setea estado a true
                      setState(() {
                        _mostrarBuscador = true;
                      });
                    },
                  ),
                ),
          ),
          //boton centrar y subir sitio
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BotonCentrar(onPressed: _userCurrentLocation),
                BotonSubir(ubicacion: _currentLocation), //le paso ubicacion 
              ],
            ),
          ),
          //sheet sitio
          if (_sitioSeleccionado != null)
            DraggableScrollableSheet(
              snap: true,
              snapSizes: const [0.40, 0.7], //para que solo tenga dos tamaños disponibles
              initialChildSize: 0.40,
              minChildSize: 0.40,
              maxChildSize: 0.7,
              builder: (context, scrollController) {
                return SitioSheet(
                  sitio: _sitioSeleccionado!,
                  etiquetas: _etiquetas ?? [],
                  scrollController: scrollController,
                  currentLocation: _currentLocation,
                );
              },
            ),
        ],
      ),
    );
  }
}
