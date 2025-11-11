import 'package:anda_tranqui/servicios/log_etiquetas.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:anda_tranqui/ui/widgets/seccion_sitio/info_horario.dart';
import 'package:anda_tranqui/ui/widgets/seccion_sitio/seccion_sitio.dart';
import 'package:anda_tranqui/servicios/formateo.dart';

class SitioSheet extends StatelessWidget {
  final Map<String, dynamic> sitio;
  final List<EtiquetaData> etiquetas;
  final ScrollController scrollController;
  final LatLng? currentLocation;
  

  const SitioSheet({
    super.key,
    required this.sitio,
    required this.etiquetas,
    required this.scrollController,
    required this.currentLocation,
    
  });

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://hqlcitdxmxjwmodyvihh.supabase.co/storage/v1/object/public/imagenes';

    final List<String> imagenesRelativas = List<String>.from(sitio['imagenes'] ?? []);
    final List<String> imagenes = imagenesRelativas.map((path) {
      String cleanPath = path.startsWith('/') ? path.substring(1) : path;
      return '$baseUrl/$cleanPath';
    }).toList();

    final rating = parseRating(sitio['promedio_estrellas']);
    final idTipoSitio = sitio['id_tipo_sitio'] ?? 0;
    final nombre = sitio['nombre_sitio'] ?? 'Sin nombre';
    final tipoSitio = sitio['tipo_sitio'] ?? 'Desconocido';
    final descripcion = sitio['descripcion'] ?? '';
    final tipoLugar = sitio['tipo_lugar'] ?? '';
    final distancia = sitio['distancia'] ?? 'Desconocida';
    final idSitio = sitio['id_sitio'];
    final double? precio = sitio['precio'] != null
      ? (sitio['precio'] as num).toDouble()
      : null;

    final List<String>? metodosPago = (sitio['metodos_pago'] as List?)?.whereType<String>().toList();
    
    final schedule = <String, DailySchedule>{
      'Lunes': {
        'start': parseTime(sitio['lunes_inicio']),
        'end': parseTime(sitio['lunes_fin']),
      },
      'Martes': {
        'start': parseTime(sitio['martes_inicio']),
        'end': parseTime(sitio['martes_fin']),
      },
      'Miércoles': {
        'start': parseTime(sitio['miercoles_inicio']),
        'end': parseTime(sitio['miercoles_fin']),
      },
      'Jueves': {
        'start': parseTime(sitio['jueves_inicio']),
        'end': parseTime(sitio['jueves_fin']),
      },
      'Viernes': {
        'start': parseTime(sitio['viernes_inicio']),
        'end': parseTime(sitio['viernes_fin']),
      },
      'Sábado': {
        'start': parseTime(sitio['sabado_inicio']),
        'end': parseTime(sitio['sabado_fin']),
      },
      'Domingo': {
        'start': parseTime(sitio['domingo_inicio']),
        'end': parseTime(sitio['domingo_fin']),
      },
    };

    return SeccionSitio(
      scrollController: scrollController,
      distancia: distancia,
      nombre: nombre,
      tipoSitio: tipoSitio,
      idTipoSitio: idTipoSitio,
      descripcion: descripcion,
      etiquetas: etiquetas,
      imagenes: imagenes,
      tipoLugar: tipoLugar,
      schedule: schedule,
      rating: rating,
      idSitio: idSitio,
      metodosPago: metodosPago,
      precio: precio

    );
  }
}
