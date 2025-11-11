import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampoTipoSitio extends StatelessWidget {
  final int? valorSeleccionado;
  final Function(int?) onChanged;

  const CampoTipoSitio({
    super.key,
    required this.valorSeleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tipo de sitio',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.45,
              child: DropdownButtonFormField<int>(
                value: valorSeleccionado,
                isExpanded: true,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                style: GoogleFonts.rubik(fontSize: 16, color: Colors.black),
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Baño')),
                  DropdownMenuItem(value: 2, child: Text('Puesto de agua potable')),
                ],
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
