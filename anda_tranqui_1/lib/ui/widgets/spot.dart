import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//para adaptabilidad considerar posibilidad de usar autosizetext para cambiar tamaño del texto

class Spot extends StatelessWidget {
  const Spot({
    super.key,
    required this.texto,
  });

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.rubik(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
