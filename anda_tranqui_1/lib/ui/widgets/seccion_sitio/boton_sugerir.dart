import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anda_tranqui/ui/pantallas/sugerir_cambios.dart';

class BotonSugerir extends StatelessWidget {
  const BotonSugerir({
    super.key,
    required this.textoBoton,
    required this.idSitio,
    required this.textoSpot,
    required this.textoTipoLugar,
    required this.idTipoSitio
  });

  final String textoBoton;
  final int idSitio;

  final String textoSpot;
  final String textoTipoLugar;
  final int idTipoSitio;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SugerirCambiosScreen(
              nombreSpot: textoSpot,
              tipoTexto: textoTipoLugar,
              idSitio: idSitio,
              idTipoSitio: idTipoSitio,
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.4,
        height: 41,
        decoration: BoxDecoration(
          color: const Color(0xFF136D91),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          textoBoton,
          style: GoogleFonts.rubik(
            color: const Color(0xFFF5F5F5),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
