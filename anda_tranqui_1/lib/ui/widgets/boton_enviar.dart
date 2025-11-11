import 'package:flutter/material.dart';

class BotonEnviar extends StatelessWidget {
  const BotonEnviar({
    super.key,
    this.texto = 'Enviar',
    required this.onPressed,
  });

  final String texto;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF136D91),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: Color(0xFFF5F5F5),
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
