import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../seccion_calificar/seccion_calificar.dart';
import '../../../servicios/log_etiquetas.dart';
class BotonCalificar extends StatelessWidget {
  const BotonCalificar({
    super.key,
    required this.idSitio,
    this.textoBoton = 'Calificar',
    required this.textoSpot,
    required this.textoTipoLugar,   
    required this.etiquetas,  
    required this.idTipoSitio, // Agregado para identificar el tipo de sitio
  });

  final String textoBoton;
  final int idSitio;
   final String textoSpot;
  final String textoTipoLugar;
  final List<EtiquetaData> etiquetas;
  final int idTipoSitio;

  @override
  Widget build(BuildContext context) {
    final anchoPantalla = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.viewInsetsOf(context),
              child: SizedBox(
                height: 650,
                child: SeccionCalificar(
                  idSitio: idSitio,
                  textoSpot: textoSpot,
                  textoTipoLugar: textoTipoLugar,
                  
                  etiquetas: etiquetas, 
                  idTipoSitio: idTipoSitio, // Aquí puedes pasar el ID del tipo de sitio si es necesario
                  ),
              ),
            );
          },
        );
      },
      child: Container(
        width: anchoPantalla * 0.4, // 40% del ancho de pantalla
        height: 44, // Alto fijo razonable para mobile
        decoration: BoxDecoration(
          color: const Color(0xFF136D91),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          textoBoton,
          style: GoogleFonts.rubik(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFF5F5F5),
          ),
        ),
      ),
    );
  }
}
