import 'package:flutter/material.dart';

class BotonBusqueda extends StatelessWidget {
  final VoidCallback onPressed;

  const BotonBusqueda({super.key, required this.onPressed});

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
          Icons.search_rounded,
          color: Colors.white,
          size: 35,
        ),
        padding: EdgeInsets.zero,
        splashRadius: 26,
      ),
    );
  }
}
