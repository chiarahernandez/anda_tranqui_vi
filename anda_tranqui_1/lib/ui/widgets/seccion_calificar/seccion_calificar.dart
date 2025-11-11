import 'dart:io';
import 'package:flutter/material.dart';
import '../boton_enviar.dart';
import '../etiquetas.dart';
import '../spot.dart';
import '../tipo_lugar.dart';
import 'estrellas_dinamicas.dart';
import 'imagen_dinamica.dart';
import '../../../../servicios/api_service.dart';
import '../alertas.dart';
import '../../../servicios/log_etiquetas.dart';

class SeccionCalificar extends StatefulWidget {
  const SeccionCalificar({
    super.key,
    required this.idSitio,
    required this.textoSpot,
    required this.textoTipoLugar,
    required this.etiquetas,
    required this.idTipoSitio,

    this.textoTituloCalificar = 'Califica este puesto',
  });

  final int idSitio;
  final int idTipoSitio; 
  final String textoTituloCalificar;
  final String textoSpot;
  final String textoTipoLugar;
  final List<EtiquetaData> etiquetas;
  @override
  State<SeccionCalificar> createState() => _SeccionCalificarState();
}

class _SeccionCalificarState extends State<SeccionCalificar> {
  final List<File> imagenesSubidas = [];
  
  int estrellasSeleccionadas = 0;

  void agregarImagen(String path) {
    setState(() {
      imagenesSubidas.add(File(path));
    });
  }

  Future<void> enviarCalificacion() async {
  if (estrellasSeleccionadas == 0.0) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: AlertaWidget(
          icono: Icons.info_outline,
          colorIcono: const Color(0xFFFFE28A),
          mensaje: 'Por favor, selecciona una cantidad de estrellas',
          onConfirmar: () => Navigator.of(context).pop(),
        ),
      ),
    );
    return;
  }

  try {
    await ApiService().subirCalificacionConImagenes(
      idSitio: widget.idSitio,
      estrellas: estrellasSeleccionadas,
      imagenes: imagenesSubidas,
    );

    //await Future.delayed(const Duration(seconds: 2)); 

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
          mensaje: 'Calificación enviada con éxito',
          onConfirmar: () {
            Navigator.of(context).pop(); 
            setState(() {
              estrellasSeleccionadas = 0;
              imagenesSubidas.clear();
            });
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
          colorIcono: const Color(0xFFF8B5B5),
          mensaje: 'Error al enviar calificación',
          onConfirmar: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.07;

    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0),
              Center(
                child: Container(
                  width: 112.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  widget.textoTituloCalificar,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20.0),
              // Etiquetas
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: widget.etiquetas.map((e) {
                    return Etiqueta(
                      texto: e.texto,
                      icono: e.icono,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 30.0),
              // Tipo de lugar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: TipoSitio(
                  texto: widget.textoTipoLugar,
                  idTipoSitio: widget.idTipoSitio,
                ),
              ),
              const SizedBox(height: 10.0),
              // Spot
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Spot(texto: widget.textoSpot),
              ),
              const SizedBox(height: 20.0),
              // Estrellas dinámicas
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: EstrellasDinamicas(
                  ratingInicial: estrellasSeleccionadas,
                  onRatingChanged: (valor) {
                    setState(() {
                      estrellasSeleccionadas = valor;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              // Imágenes dinámicas
              Padding(
                padding: EdgeInsets.only(left: horizontalPadding),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...imagenesSubidas.map(
                        (file) => Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: ImagenDinamica(imagenUrl: file.path),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
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
              const SizedBox(height: 20.0),
              Center(
                child: BotonEnviar(
                  onPressed: enviarCalificacion,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
