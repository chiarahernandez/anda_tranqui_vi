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

  Future<void> subirSitio(
      Map<String, dynamic> datosSitio,
      {List<Uint8List>? imagenesBytes}
    ) async {
      try {

        final urlCrearSitio = Uri.parse('$baseUrl/sitios/');
        print('POST crear sitio → $urlCrearSitio');

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

        print('STATUS crear sitio: ${sitioRes.statusCode}');
        print('BODY: ${sitioRes.body}');

        if (sitioRes.statusCode != 201) throw Exception('Error al crear sitio');

        final idSitio = jsonDecode(sitioRes.body)['id_sitio'];
        print('✔ sitio creado con id: $idSitio');


        final urlCrearHorario = Uri.parse('$baseUrl/horario_semanal/');
        final horarios = datosSitio['horarios'];

        final horarioRes = await http.post(
          urlCrearHorario,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id_sitio': idSitio,
            ...horarios,
          }),
        );

        if (horarioRes.statusCode != 201) throw Exception('Error al cargar horarios');
        final idHorario = jsonDecode(horarioRes.body)['id_horario_semanal'];

        final urlCrearInfoSitio = Uri.parse('$baseUrl/info_sitios/');

        final infoRes = await http.post(
          urlCrearInfoSitio,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id_sitio': idSitio,
            'id_horario_semanal': idHorario,
            'descripcion': datosSitio['detalle'],
            'gratis': datosSitio['es_gratis'],
            'adaptable': datosSitio['es_adaptado'],
            'precio': datosSitio['precio'],
            'id_limpieza': datosSitio['limpieza'],
            'id_tipo_lugar': datosSitio['id_tipo_lugar'],
            'id_metodo': datosSitio['metodos_pago'].isNotEmpty
                ? datosSitio['metodos_pago'][0]
                : null,
          }),
        );

        if (infoRes.statusCode != 201) throw Exception('Error al cargar info sitio');

        if (imagenesBytes != null && imagenesBytes.isNotEmpty) {
          await subirImagenesBytesSitio(idSitio: idSitio, imagenesBytes: imagenesBytes);
        }

        print('Sitio cargado correctamente con imágenes');
      } catch (e) {
        print('Error en subirSitio: $e');
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
            'imagen',  // mismo campo que backend espera
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
              })
          .toList();
    } else {
      print('Error al obtener sitios: ${response.statusCode}');
      return [];
    }
  }

  Future<Map<String, dynamic>?> obtenerInfoSitioPorId(int idSitio) async {
    final url = Uri.parse('$baseVistaUrl/$idSitio');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      print('Error al obtener info completa del sitio $idSitio: ${response.statusCode}');
      return null;
    }
  }

  Future<void> subirCalificacionConImagenes({
        required int idSitio,
        required int estrellas,
        required List<Uint8List> imagenesBytes, 
    }) async {
        final calificacionResponse = await http.post(
        Uri.parse('$baseUrl/calificaciones/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
        'id_sitio': idSitio,
        'estrellas': estrellas,
        }),
        );

      if (calificacionResponse.statusCode != 201) {
        throw Exception('Error al guardar calificación: ${calificacionResponse.body}');
      }

      //ahora carga las imagenes usando los bytes y MultipartFile.fromBytes
      for (final bytes in imagenesBytes) {
      final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/imagenes/'),
      );
      request.fields['id_sitio'] = idSitio.toString();

      final fileName = '${DateTime.now().millisecondsSinceEpoch}-${idSitio}.jpg'; 

      // Usamos fromBytes en lugar de fromPath
      request.files.add(
      http.MultipartFile.fromBytes(
      'imagen', 
      bytes,
              filename: fileName, 
              ),
            );

            final response = await request.send();
            if (response.statusCode != 201) {
            final error = await response.stream.bytesToString();
            throw Exception('Error al subir una imagen: $error');
          }
        }
  }

  Future<void> subirSugerencia(Map<String, dynamic> sugerencia) async {
    final url = Uri.parse('$baseUrl/sugerencias/'); 

    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(sugerencia),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al subir sugerencia: ${response.body}');
    }
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