import 'package:flutter/material.dart';

class BotonCentrar extends StatelessWidget {
  final VoidCallback onPressed;

  const BotonCentrar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF4A949A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.my_location_rounded,
          size: 30,
          color: Colors.white,
        ),
        splashRadius: 28,
        tooltip: 'Centrar ubicación',
      ),
    );
  }
}
