import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';


class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/anda_tranqui';
  static const String baseVistaUrl = 'http://10.0.2.2:5000/anda_tranqui/vistas';

  Future<void> getDatos() async {
    var url = Uri.parse('http://10.0.2.2:5000/anda_tranqui'); 
    var response = await http.get(url);

    if (response.statusCode == 200) {
      print('Respuesta: ${response.body}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }

    Future<void> subirSitio(Map<String, dynamic> datosSitio,
    {List<Uint8List>? imagenesBytes}
  ) async {
  try {
    // 1) Crear sitio
    final urlCrearSitio = Uri.parse('$baseUrl/sitios/');
    final sitioRes = await http.post(
      urlCrearSitio,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_tipo_sitio': datosSitio['id_tipo_sitio'],
        'nombre': datosSitio['nombre'],
        'latitud': datosSitio['latitud'],
        'longitud': datosSitio['longitud'],
        'estado': 'A',
      }),
    );

    if (sitioRes.statusCode != 201) {
      throw Exception('Error al crear sitio: ${sitioRes.statusCode} ${sitioRes.body}');
    }
    final idSitio = jsonDecode(sitioRes.body)['id_sitio'];
    print('✔ sitio creado id: $idSitio');

    // Crear horario semanal
    final urlCrearHorario = Uri.parse('$baseUrl/horario_semanal/');
    final horarios = datosSitio['horarios'] ?? {};
    final horarioRes = await http.post(
      urlCrearHorario,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_sitio': idSitio,
        ...horarios,
      }),
    );

    if (horarioRes.statusCode != 201) {
      throw Exception('Error al crear horario: ${horarioRes.statusCode} ${horarioRes.body}');
    }
    final idHorario = jsonDecode(horarioRes.body)['id_horario_semanal'];
    print('✔ horario creado id: $idHorario');

    final urlCrearInfoSitio = Uri.parse('$baseUrl/info_sitios/');

    List<dynamic>? metodosPago = datosSitio['metodos_pago'] as List<dynamic>?;
    if (metodosPago != null) {
      metodosPago = metodosPago.where((m) => m != null).map((m) {
        if (m is String) return int.tryParse(m) ?? m;
        return m;
      }).toList();
    }

    final infoBody = {
      'id_sitio': idSitio,
      'id_horario_semanal': idHorario,
      'descripcion': datosSitio['detalle'],
      'gratis': datosSitio['es_gratis'],
      'adaptable': datosSitio['es_adaptado'],
      'precio': datosSitio['precio'],
      'id_limpieza': datosSitio['limpieza'],
      'id_tipo_lugar': datosSitio['id_tipo_lugar'],
      if (metodosPago != null && metodosPago.isNotEmpty)
        'id_sitio_metodo_pago': metodosPago,
    };

    final infoRes = await http.post(
      urlCrearInfoSitio,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(infoBody),
    );

    if (infoRes.statusCode != 201) {
      throw Exception('Error al crear info_sitio: ${infoRes.statusCode} ${infoRes.body}');
    }

    print('✔ info_sitio creada y métodos (si los enviaron)');

    if (imagenesBytes != null && imagenesBytes.isNotEmpty) {
      await subirImagenesBytesSitio(idSitio: idSitio, imagenesBytes: imagenesBytes);
    }

    print('✔ Sitio cargado exitosamente con todo.');

  } catch (e) {
    print('Error en subirSitio: $e');
    rethrow;
  }
}


    Future<void> subirImagenesBytesSitio({
      required int idSitio,
      required List<Uint8List> imagenesBytes,
    }) async {
      final url = Uri.parse('$baseUrl/imagenes/');

      print('Cargando ${imagenesBytes.length} imágenes para sitio $idSitio...');

      for (int i = 0; i < imagenesBytes.length; i++) {
        final bytes = imagenesBytes[i];

        final request = http.MultipartRequest('POST', url);
        request.fields['id_sitio'] = idSitio.toString();

        final fileName = '${DateTime.now().millisecondsSinceEpoch}-$i-$idSitio.jpg';

        request.files.add(
          http.MultipartFile.fromBytes(
            'imagen',  
            bytes,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        print('IMG[$i] → status ${response.statusCode}, body: $responseBody');

        if (response.statusCode != 201) {
          throw Exception('Error al subir imagen: $responseBody');
        }
      }

      print('Todas las imágenes subidas correctamente');
    }


  Future<List<Map<String, dynamic>>> obtenerSitios() async {
    final url = Uri.parse('$baseUrl/sitios/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Filtramos solo sitios activos y extraemos los datos mínimos
      return data
          .where((sitio) => sitio['estado'] == 'A')
          .map<Map<String, dynamic>>((sitio) => {
                'id_sitio': sitio['id_sitio'],
                'latitud': double.tryParse(sitio['latitud'].toString()) ?? 0.0,
                'longitud': double.tryParse(sitio['longitud'].toString()) ?? 0.0,
                'id_tipo_sitio': sitio['id_tipo_sitio'],
                'nombre': sitio['nombre'] ?? 'Sin nombre',
              })
          .toList();
    } else {
      print('Error al obtener sitios: ${response.statusCode}');
      return [];
    }
  }

  Future<Map<String, dynamic>?> obtenerInfoSitioPorId(int idSitio) async {
    try {

      final urlVista = Uri.parse('$baseVistaUrl/$idSitio');
      final vistaRes = await http.get(urlVista);

      if (vistaRes.statusCode != 200) {
        print('Error al obtener datos de la vista: ${vistaRes.statusCode} ${vistaRes.body}');
        return null;
      }

      final Map<String, dynamic> data = jsonDecode(vistaRes.body);
      final String? metodosString = data['metodos_pago'] as String?;
      
      List<String> metodosPagoNombres = (metodosString != null && metodosString.isNotEmpty)
          ? metodosString.split(', ')
          : [];
   
      final String? urlsString = data['urls_imagenes'] as String?;

      List<String> imagenesUrls = [];

      if (urlsString != null && urlsString.isNotEmpty) {
        imagenesUrls = urlsString.split(',').map((urlRaw) {
          final u = urlRaw.trim();

          if (u.startsWith('http')) return u;

          return 'https://anda-tranqui.s3.us-east-2.amazonaws.com/$u';
        }).toList();
      }

      final result = {
        ...data,
        'imagenes': imagenesUrls, 
        'metodos_pago': metodosPagoNombres,
      };

      return result;
      
    } catch (e) {
      print('Error obtener info por id (Versión Vista): $e');
      return null;
    }
  }


  Future<void> subirCalificacionConImagenes({ required int idSitio, required int estrellas, List<dynamic>? metodosPago, List<Uint8List>? imagenesBytes,}) async {
  try {
    print('Subiendo calificación para sitio $idSitio...');

    if (metodosPago != null) {
      metodosPago = metodosPago.where((m) => m != null).map((m) {
        if (m is String) return int.tryParse(m) ?? m;
        return m;
      }).toList();
    }

    // Crear calificación
    final urlCrearCalificacion = Uri.parse('$baseUrl/calificaciones/');
    final calificacionBody = {
      'id_sitio': idSitio,
      'estrellas': estrellas,
      if (metodosPago != null && metodosPago.isNotEmpty)
        'id_calificacion_metodo_pago': metodosPago,
    };

    final calificacionRes = await http.post(
      urlCrearCalificacion,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(calificacionBody),
    );

    if (calificacionRes.statusCode != 201) {
      throw Exception(
        'Error al crear calificación: ${calificacionRes.statusCode} ${calificacionRes.body}',
      );
    }

    final idCalificacion = jsonDecode(calificacionRes.body)['id_calificacion'];
    print('✔ Calificación creada id: $idCalificacion');

    if (imagenesBytes != null && imagenesBytes.isNotEmpty) {
      print('Subiendo ${imagenesBytes.length} imágenes...');

      for (int i = 0; i < imagenesBytes.length; i++) {
        final bytes = imagenesBytes[i];

        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$baseUrl/imagenes/'),
        );

        request.fields['id_sitio'] = idSitio.toString();
        request.fields['id_calificacion'] = idCalificacion.toString();

        final fileName =
            'calif-${DateTime.now().millisecondsSinceEpoch}-$i-$idSitio.jpg';

        request.files.add(
          http.MultipartFile.fromBytes(
            'imagen',
            bytes,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        print('IMG_CAL[$i] → status ${response.statusCode}, body: $responseBody');

        if (response.statusCode != 201) {
          throw Exception('Error al subir imagen: $responseBody');
        }
      }

      print('✔ Todas las imágenes de la calificación subidas');
    }

    print('Calificación cargada con éxito (con métodos y fotos)');

  } catch (err) {
    print('Error en subirCalificacionConImagenes: $err');
    rethrow;
  }
}


 Future<void> subirSugerencia(Map<String, dynamic> sugerencia) async {
  final url = Uri.parse('$baseUrl/sugerencias/');

  List<dynamic>? metodosPago = sugerencia['metodos_pago'];
  if (metodosPago != null) {
    metodosPago = metodosPago.where((m) => m != null).map((m) {
      if (m is String) return int.tryParse(m) ?? m;
      return m;
    }).toList();
  }

  final body = {
    ...sugerencia,
    if (metodosPago != null && metodosPago.isNotEmpty)
      'id_sitio_metodo_pago': metodosPago,
  };

  final response = await http.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception('Error al subir sugerencia: ${response.body}');
  }

  print("✔ Sugerencia enviada con métodos (si había)");
}


  Future<void> subirImagenesSitio({
    required int idSitio,
    required List<File> imagenes,
  }) async {
    final url = Uri.parse('$baseUrl/imagenes/');

    for (final imagen in imagenes) {
      final request = http.MultipartRequest('POST', url);

      request.fields['id_sitio'] = idSitio.toString();

      request.files.add(
        await http.MultipartFile.fromPath(
          'imagen',         
          imagen.path,
        ),
      );

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();
      print('Respuesta subida imagen: status ${response.statusCode}, body: $responseBody');

      if (response.statusCode != 201) {
        throw Exception('Error al subir imagen: ${response.reasonPhrase}');
      }
    }

    print('Todas las imágenes del sitio $idSitio subidas correctamente');
  }


}