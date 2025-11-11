import 'package:anda_tranqui/servicios/log_etiquetas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../etiquetas.dart';
import '../tipo_lugar.dart';
import '../spot.dart';
import 'estrellas_estaticas.dart';
import 'imagen_estatica.dart';
import 'info_horario.dart';
import 'info_tipo_lugar.dart';
import 'info_descripcion.dart';
import 'boton_calificar.dart';
import 'boton_sugerir.dart';
import 'info_precio.dart'; 

class SeccionSitio extends StatefulWidget {
  const SeccionSitio({
    super.key,
    this.alturaSeccion = 600,
    required this.distancia,
    required this.scrollController,
    required this.nombre,
    required this.tipoSitio,
    required this.descripcion,
    required this.etiquetas,
    required this.imagenes,
    required this.tipoLugar,
    required this.schedule,
    required this.rating,
    required this.idSitio,
    required this.idTipoSitio,
    this.metodosPago,
    this.precio,
  });

  final double alturaSeccion;
  final String distancia;
  final ScrollController scrollController;

  final String nombre;
  final String tipoSitio;
  final String descripcion;
  final List<EtiquetaData> etiquetas;
  final List<String> imagenes;
  final String tipoLugar;
  final Map<String, DailySchedule> schedule;
  final double rating;
  final int idSitio;
  final List<String>? metodosPago;
  final double? precio;
  final int idTipoSitio; 

  @override
  State<SeccionSitio> createState() => _SeccionSitioState();
}

class _SeccionSitioState extends State<SeccionSitio> {
  @override
  Widget build(BuildContext context) {
    
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        width: double.infinity,
        height: widget.alturaSeccion,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ▪ Barrita superior
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: screenWidth * 0.3,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),

              // ▪ Etiquetas
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

              // ▪ Tipo de lugar
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: TipoSitio(
                  texto: widget.tipoSitio,
                  idTipoSitio: widget.idTipoSitio,
                ),
              ),

              // ▪ Nombre del spot
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Spot(texto: widget.nombre),
              ),

              // ▪ Rating + Distancia
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EstrellasEstaticas(valor: widget.rating),
                    Text(
                      widget.distancia,
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // ▪ Carrusel de imágenes o placeholder
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                child: SizedBox(
                  height: screenWidth * 0.45,
                  child: widget.imagenes.isNotEmpty
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: widget.imagenes.map((url) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: ImagenEstatica(url: url),
                              );
                            }).toList(),
                          ),
                        )
                      : const ImagenEstatica(), // <-- placeholder único
                ),
              ),

              // ▪ Horarios
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: InfoHorario(schedule: widget.schedule),
              ),

              // ▪ Tipo de servicio
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                child: InfoTipoLugar(
                  texto: widget.tipoLugar,
                  icono: const Icon(Icons.public, size: 20),
                ),
              ),

              // ▪ InfoPrecio (solo si no es gratis)
              if (widget.metodosPago != null && widget.precio != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
                  child: MetodoPagoYPrecio(
                    metodoPago: widget.metodosPago!,
                    precio: widget.precio!,
                  ),
                ),
              //aca termina el if
            
              // ▪ Descripción
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: InfoDescripcion(
                  texto: widget.descripcion,
                  icono: const Icon(Icons.description),
                ),
              ),

              // ▪ Botones
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BotonCalificar(
                      textoBoton: 'Calificar',
                      idSitio: widget.idSitio,
                      etiquetas: widget.etiquetas,
                      textoSpot: widget.nombre,
                      textoTipoLugar: widget.tipoSitio,
                      idTipoSitio: widget.idTipoSitio,
                    ),
                    BotonSugerir(
                      textoBoton: 'Sugerir cambios',
                      idSitio: widget.idSitio,
                      textoSpot: widget.nombre,
                      textoTipoLugar: widget.tipoSitio,
                     
                      idTipoSitio: widget.idTipoSitio,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
