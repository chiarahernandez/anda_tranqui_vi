import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonUbicacion extends StatelessWidget {
  final VoidCallback onPressed;

  const BotonUbicacion({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.edit_location_alt, color: Color(0xFF4A949A)),
      label: Text(
        'Ajustar ubicación',
        style: GoogleFonts.rubik(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: const Color(0xFFE5F2F3), // Fondo pastel celeste
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: Color(0xFF4A949A), width: 1),
      ),
      onPressed: onPressed,
    );
  }
}
