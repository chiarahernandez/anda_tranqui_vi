import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//considerar posibilidad de usar boton de 'ver mas' para que no quede todo el textote, hay que ver como se ve asi 

class InfoDescripcion extends StatelessWidget {
  const InfoDescripcion({
    super.key,
    required this.texto,
    this.icono = const Icon(Icons.description_rounded, size: 28, color: Colors.black),
  });

  final String texto;
  final Widget icono;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 10),
          child: SizedBox(
            width: 28,
            child: icono,
          ),
        ),
        Expanded(
          child: Text(
            texto.length > 300 ? texto.substring(0, 300) + '...' : texto,
            style: GoogleFonts.rubik(
              fontSize: screenWidth < 360 ? 14 : 16,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
