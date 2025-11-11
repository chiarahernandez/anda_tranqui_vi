import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//noseporque a este le puse el icono como variable kajsksj
class InfoTipoLugar extends StatelessWidget {
  const InfoTipoLugar({
    super.key,
    required this.texto,
    required this.icono,
  });

  final String texto;
  final Widget icono;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 28,
            height: 28,
            child: Center(child: icono),
          ),
        ),
        Expanded(
          child: Text(
            texto,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.rubik(
              fontSize: screenWidth < 360 ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
