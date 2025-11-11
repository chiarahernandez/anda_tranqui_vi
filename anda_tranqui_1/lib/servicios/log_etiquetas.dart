
import 'package:flutter/material.dart';

class EtiquetaData {
  final String texto;
  final IconData? icono;

  EtiquetaData({required this.texto, this.icono});
}

List<EtiquetaData> generarEtiquetas({
  required bool gratis,
  required bool adaptable,
  required String limpiezaTexto,
}) {
  return [
    EtiquetaData(
      texto: gratis ? 'Gratis' : 'Pago',
      icono: Icons.attach_money,
    ),
    EtiquetaData(
      texto: adaptable ? 'Adaptado' : 'Sin adaptar',
      icono: Icons.accessible, // ícono de silla de ruedas
    ),
    EtiquetaData(
      texto: limpiezaTexto.isNotEmpty ? limpiezaTexto : 'Sin datos',
      icono: Icons.cleaning_services, // ícono de limpieza
    ),
  ];
}