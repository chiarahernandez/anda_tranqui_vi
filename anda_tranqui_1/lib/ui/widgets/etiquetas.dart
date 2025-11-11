import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Etiqueta extends StatelessWidget {
  const Etiqueta({
    super.key,
    this.texto = 'Gratis',
    this.icono,
  });

  final String texto;
  final IconData? icono;

  @override
  Widget build(BuildContext context) {
    const textoColor = Color(0xFF196C3F);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFB2D8C3),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icono != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                icono,
                size: 14,
                color: textoColor,
              ),
            ),
          Text(
            texto,
            style: GoogleFonts.rubik(
              color: textoColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

//para cambiar texto Etiqueta(texto: 'Público'),

