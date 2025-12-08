import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../servicios/api_service.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../widgets/campo_tipo_sitio.dart';
import '../widgets/campo_nombre.dart';
import '../widgets/campo_horario.dart';
import '../widgets/campo_tipo_lugar.dart';
import '../widgets/campo_limpieza.dart';
import '../widgets/campo_precio.dart';
import '../widgets/campo_metodo.dart';
import '../widgets/campo_detalle.dart';
import '../widgets/cuadrito_switch.dart';
import '../widgets/boton_enviar.dart';
import '../widgets/alertas.dart';
import 'selector_ubicacion.dart';
import '../widgets/boton_ubicacion.dart';
import '../widgets/seccion_calificar/imagen_dinamica.dart';

import '../../../../servicios/image_processor.dart';

class SubirSitioScreen extends StatefulWidget {
  final LatLng ubicacion;

  const SubirSitioScreen({super.key, required this.ubicacion});

  @override
  State<SubirSitioScreen> createState() => _SubirSitioScreenState();
}

class _SubirSitioScreenState extends State<SubirSitioScreen> {
  int? tipoSitioId;
  String? nombre;
  String? disponibilidad;
  Map<String, String?> horarios = {};
  int? tipoLugarId;
  int? limpieza;
  double? precio;
  List<int> metodosPago = [];
  bool esGratis = true;
  bool esAdaptado = false;
  String? detalle;
  late LatLng _ubicacionElegida;
  List<File> imagenesSubidas = [];

  @override
  void initState() {
    super.initState();
    _ubicacionElegida = widget.ubicacion;
  }

  void agregarImagen(String path) {
    setState(() {
      imagenesSubidas.add(File(path));
    });
  }

  Future<void> _guardar() async {
    final sitio = {
      'id_tipo_sitio': tipoSitioId,
      'nombre': nombre,
      'disponibilidad': disponibilidad,
      'horarios': horarios,
      'id_tipo_lugar': tipoLugarId,
      'limpieza': limpieza,
      'precio': esGratis ? null : precio,
      'metodos_pago': metodosPago,
      'es_adaptado': esAdaptado,
      'es_gratis': esGratis,
      'detalle': detalle,
      'latitud': _ubicacionElegida.latitude,
      'longitud': _ubicacionElegida.longitude,
    };

    try {
      List<Uint8List> listaDeBytesProcesados = [];

      if (imagenesSubidas.isNotEmpty) {
        final tareas = imagenesSubidas.map(
          (file) => compute(procesarYComprimirImagen, file),
        );

        listaDeBytesProcesados = await Future.wait(tareas.toList());
      }

      await ApiService().subirSitio(
        sitio,
        imagenesBytes: listaDeBytesProcesados,
      );

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: AlertaWidget(
            icono: Icons.check_circle_outline_rounded,
            colorIcono: const Color(0xFFB2D8C3),
            mensaje: 'Sitio cargado con éxito',
            onConfirmar: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: AlertaWidget(
            icono: Icons.error_outline,
            colorIcono: const Color(0xFFE89092),
            mensaje: 'Error al cargar el sitio',
            onConfirmar: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A949A), size: 35),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Subir nuevo Sitio',
          style: GoogleFonts.rubik(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CampoTipoSitio(
              valorSeleccionado: tipoSitioId,
              onChanged: (val) => setState(() => tipoSitioId = val),
            ),
            const SizedBox(height: 24),
            CampoNombre(
              valorInicial: nombre,
              onChanged: (val) => setState(() => nombre = val),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: BotonUbicacion(
                onPressed: () async {
                  final nuevaUbicacion = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectorUbicacionScreen(
                        ubicacionInicial: _ubicacionElegida,
                      ),
                    ),
                  );

                  if (nuevaUbicacion != null && mounted) {
                    setState(() {
                      _ubicacionElegida = nuevaUbicacion;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CuadritoSwitchWidget(
                    texto: 'Gratis',
                    valor: esGratis,
                    onChanged: (val) => setState(() => esGratis = val),
                  ),
                  CuadritoSwitchWidget(
                    texto: 'Apto',
                    valor: esAdaptado,
                    onChanged: (val) => setState(() => esAdaptado = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CampoHorario(
              titulo: 'Horario de atención',
              onChanged: (map) => setState(() => horarios = map),
            ),
            const SizedBox(height: 24),
            CampoTipoLugar(
              valores: const [1, 2, 3, 4],
              etiquetas: const ['Espacio Público', 'Tienda', 'Café', 'Gasolinera'],
              valorSeleccionado: tipoLugarId,
              onChanged: (val) => setState(() => tipoLugarId = val),
            ),
            const SizedBox(height: 24),
            CampoLimpieza(
              valorSeleccionado: limpieza,
              onChanged: (val) => setState(() => limpieza = val),
            ),
            const SizedBox(height: 24),
            if (!esGratis) ...[
              CampoPrecioWidget(
                valorInicial: precio,
                onChanged: (val) => setState(() => precio = val),
              ),
              const SizedBox(height: 16),
              CampoMetodoWidget(
                metodosSeleccionados: metodosPago,
                onChanged: (lista) => setState(() => metodosPago = lista),
              ),
              const SizedBox(height: 24),
            ],
            CampoDetalle(
              maxLength: 300,
              valorInicial: detalle,
              onChanged: (val) => setState(() => detalle = val),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...imagenesSubidas.map(
                      (file) => Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: ImagenDinamica(imagenUrl: file.path),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ImagenDinamica(
                        onImagenSeleccionada: (archivo) {
                          agregarImagen(archivo.path);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: BotonEnviar(
                texto: 'Enviar',
                onPressed: _guardar,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
