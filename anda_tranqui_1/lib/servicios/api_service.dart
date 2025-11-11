import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> getDatos() async {
    try {
      final List<Map<String, dynamic>> data = await _supabase.from('sitios').select();
      print('Datos de Supabase (tabla sitios): $data');
    } catch (e) {
      print('Error al obtener datos de Supabase: $e');
    }
  }

   Future<void> subirSitio(Map<String, dynamic> datosSitio, {List<File>? imagenes}) async {
    try {
      final List<Map<String, dynamic>> sitioRes = await _supabase.from('sitios').insert({
        'id_tipo_sitio': datosSitio['id_tipo_sitio'],
        'nombre': datosSitio['nombre'],
        'latitud': datosSitio['latitud'],
        'longitud': datosSitio['longitud'],
        'estado': 'A',
      }).select();

      if (sitioRes.isEmpty) throw Exception('Error al crear sitio');
      final int idSitio = sitioRes[0]['id_sitio'];

      final Map<String, dynamic> horarios = datosSitio['horarios'];
      final List<Map<String, dynamic>> horarioRes = await _supabase.from('horario_semanal').insert({
        'id_sitio': idSitio,
        'lunes_inicio': horarios['lunes_inicio'],
        'lunes_fin': horarios['lunes_fin'],
        'martes_inicio': horarios['martes_inicio'],
        'martes_fin': horarios['martes_fin'],
        'miercoles_inicio': horarios['miercoles_inicio'],
        'miercoles_fin': horarios['miercoles_fin'],
        'jueves_inicio': horarios['jueves_inicio'],
        'jueves_fin': horarios['jueves_fin'],
        'viernes_inicio': horarios['viernes_inicio'],
        'viernes_fin': horarios['viernes_fin'],
        'sabado_inicio': horarios['sabado_inicio'],
        'sabado_fin': horarios['sabado_fin'],
        'domingo_inicio': horarios['domingo_inicio'],
        'domingo_fin': horarios['domingo_fin'],
      }).select();

      if (horarioRes.isEmpty) throw Exception('Error al cargar horarios');
      final int idHorario = horarioRes[0]['id_horario_semanal'];

      await _supabase.from('info_sitios').insert({
        'id_sitio': idSitio,
        'id_horario_semanal': idHorario,
        'descripcion': datosSitio['detalle'],
        'gratis': datosSitio['es_gratis'],
        'adaptable': datosSitio['es_adaptado'],
        'precio': datosSitio['precio'],
        'id_limpieza': datosSitio['limpieza'],
        'id_tipo_lugar': datosSitio['id_tipo_lugar'],
      });

      if (datosSitio['metodos_pago'] != null && datosSitio['metodos_pago'].isNotEmpty) {
        final List<Map<String, dynamic>> metodosPagoInserts = [];
        for (final metodoId in (datosSitio['metodos_pago'] as List)) {
          metodosPagoInserts.add({
            'id_sitio': idSitio,
            'id_metodo': metodoId,
          });
        }
        await _supabase.from('sitio_metodo_pago').insert(metodosPagoInserts).select();
        
      }

      if (imagenes != null && imagenes.isNotEmpty) {
        await subirImagenesSitio(idSitio: idSitio, imagenes: imagenes);
      }

      print('Sitio, horarios, info y métodos de pago creados correctamente.');

    } catch (e) {
      print('Error al subir sitio y datos relacionados: $e');
      throw e;
    }
  }


  Future<List<Map<String, dynamic>>> obtenerSitios() async {
    try {
      final List<dynamic> data = await _supabase
          .from('sitios')
          .select()
          .eq('estado', 'A');

      return data
          .map<Map<String, dynamic>>((sitio) => {
                'id_sitio': sitio['id_sitio'],
                'latitud': double.tryParse(sitio['latitud'].toString()) ?? 0.0,
                'longitud': double.tryParse(sitio['longitud'].toString()) ?? 0.0,
                'id_tipo_sitio': sitio['id_tipo_sitio'],
                'nombre': sitio['nombre'] ?? 'Sin nombre',
              })
          .toList();
    } catch (e) {
      print('Error al obtener sitios: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> obtenerInfoSitioPorId(int idSitio) async {
    try {
          final List<Map<String, dynamic>> sitioDataList = await _supabase
          .from('vista_info_completa') 
          .select()
          .eq('id_sitio', idSitio);

      if (sitioDataList.isEmpty) {
        return null;
      }

      final Map<String, dynamic> result = Map.from(sitioDataList.first);

      final List<dynamic> imagenesData = await _supabase
          .from('imagenes')
          .select('url')
          .eq('id_sitio', idSitio);

      final List<String> imageUrls = imagenesData
          .map((e) => e['url'] as String)
          .toList();
      result['imagenes'] = imageUrls;

      final List<dynamic> metodosPagoData = await _supabase
          .from('sitio_metodo_pago')
          .select('metodos(nombre)') 
          .eq('id_sitio', idSitio);

      final List<String> metodosPagoNombres = metodosPagoData
          .map((e) {
            final metodoMap = e['metodos'] as Map<String, dynamic>?;
            return metodoMap?['nombre'] as String?;
          })
          .whereType<String>() 
          .toList();

      result['metodos_pago'] = metodosPagoNombres;

      return result;
    } catch (e) {
      print('Error al obtener info completa del sitio $idSitio de Supabase: $e');
      return null;
    }
  }

  Future<void> subirCalificacionConImagenes({
    required int idSitio,
    required int estrellas,
    required List<File> imagenes,
  }) async {
    try {
      await _supabase.from('calificaciones').insert({
        'id_sitio': idSitio,
        'estrellas': estrellas,
      });

      await subirImagenesSitio(idSitio: idSitio, imagenes: imagenes);

    } catch (e) {
      print('Error al subir calificación o imágenes a Supabase: $e');
      throw e;
    }
  }

    Future<void> subirSugerencia(Map<String, dynamic> sugerencia) async {
      try {
        final Map<String, dynamic> dataSugerencia = {
          'id_sitio': sugerencia['id_sitio'],
          'id_tipo_sitio': sugerencia['id_tipo_sitio'],
          'id_tipo_lugar': sugerencia['id_tipo_lugar'],
          'id_limpieza': sugerencia['id_limpieza'],
          'id_disponibilidad': sugerencia['id_disponibilidad'],
          'precio': sugerencia['precio'],
          'gratis': sugerencia['gratis'],
          'adaptable': sugerencia['adaptable'],
          'lunes_inicio': sugerencia['lunes_inicio'],
          'lunes_fin': sugerencia['lunes_fin'],
          'martes_inicio': sugerencia['martes_inicio'],
          'martes_fin': sugerencia['martes_fin'],
          'miercoles_inicio': sugerencia['miercoles_inicio'],
          'miercoles_fin': sugerencia['miercoles_fin'],
          'jueves_inicio': sugerencia['jueves_inicio'],
          'jueves_fin': sugerencia['jueves_fin'],
          'viernes_inicio': sugerencia['viernes_inicio'],
          'viernes_fin': sugerencia['viernes_fin'],
          'sabado_inicio': sugerencia['sabado_inicio'],
          'sabado_fin': sugerencia['sabado_fin'],
          'domingo_inicio': sugerencia['domingo_inicio'],
          'domingo_fin': sugerencia['domingo_fin'],
        };
        final List<Map<String, dynamic>> sugerenciaRes = await _supabase
            .from('sugerencias')
            .insert(dataSugerencia)
            .select();
        if (sugerenciaRes.isEmpty) throw Exception('No se pudo insertar la sugerencia');

        final int idSugerencia = sugerenciaRes[0]['id_sugerencias'];

        final metodos = sugerencia['metodos_pago'] as List?;
        if (metodos != null && metodos.isNotEmpty) {
          final List<Map<String, dynamic>> inserts = metodos.map((metodoId) {
            return {
              'id_sugerencias': idSugerencia,
              'id_metodo': metodoId,
            };
          }).toList();
           print('Inserts a sugerencia_metodo_pago: $inserts');
          await _supabase.from('sugerencia_metodo_pago').insert(inserts).select();
          print('Métodos de pago insertados correctamente.');
        }

      } catch (e) {
        print(' Error al subir sugerencia a Supabase: $e');
        throw e;
      }
    }

  Future<void> subirImagenesSitio({
    required int idSitio, 
    required List<File> imagenes,
  }) async {
    for (final imagen in imagenes) {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}-${imagen.path.split('/').last}';
      final String storagePath = '1ktc4f5_0/$fileName'; 

      try {
        await _supabase.storage.from('imagenes').upload(
          storagePath,
          imagen,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

        final String publicUrl = _supabase.storage.from('imagenes').getPublicUrl(storagePath);

        print('Imagen $fileName subida correctamente al Storage para el sitio $idSitio. URL: $publicUrl');

        await _supabase.from('imagenes').insert({
            'id_sitio': idSitio,
            'url': storagePath, 
        });
        print('URL de imagen insertada correctamente en la tabla "imagenes".');

      } on StorageException catch (e) {
        print('Error de Storage al subir imagen $fileName: ${e.message}');
        throw Exception('Error al subir una imagen al Storage: ${e.message}');
      } catch (e) {
        print('Error desconocido al subir imagen $fileName y/o guardar URL: $e');
        throw Exception('Error desconocido al subir una imagen y/o guardar su URL: $e');
      }
    }
  }

}