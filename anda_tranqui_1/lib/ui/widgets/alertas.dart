import 'package:flutter/material.dart';

class AlertaWidget extends StatelessWidget {
  final IconData icono;
  final Color colorIcono;
  final String mensaje;
  final VoidCallback onConfirmar;

  const AlertaWidget({
    super.key,
    required this.icono,
    required this.colorIcono,
    required this.mensaje,
    required this.onConfirmar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Adaptable
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4A949A),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              color: colorIcono,
              size: 50,
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onConfirmar,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4A949A), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: const Color(0xFF4A949A),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Ir al inicio',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
