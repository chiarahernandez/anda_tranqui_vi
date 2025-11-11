import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TipoSitio extends StatelessWidget {
  const TipoSitio({
    super.key,
    required this.texto,
    required this.idTipoSitio,
  });

  final String texto;
  final int idTipoSitio;

  IconData _obtenerIconoPorTipo(int idTipoSitio) {
    
    switch (idTipoSitio) {
      case 1:
        return Icons.wc; // Baño
      case 2:
        return Icons.local_drink; // Agua potable
      default:
        return Icons.place; // Otro
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 31.0,
            alignment: Alignment.center,
            child: Icon(
              _obtenerIconoPorTipo(idTipoSitio),
              size: 24.0,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              texto,
              style: GoogleFonts.rubik(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
