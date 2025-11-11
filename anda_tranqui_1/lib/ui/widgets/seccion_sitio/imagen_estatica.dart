import 'package:flutter/material.dart';

class ImagenEstatica extends StatelessWidget {
  const ImagenEstatica({
    super.key,
    this.url,
    this.radio = 14,
  });

  final String? url;
  final double radio;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final ancho = screenWidth * 0.45; // 45% del ancho de pantalla
    final alto = ancho; // cuadrado

    return Container(
      width: ancho,
      height: alto,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(radio),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radio),
        child: url != null && url!.isNotEmpty
            ? Image.network(
                url!,
                width: ancho,
                height: alto,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                ),
              )
            : const Center(
                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
      ),
    );
  }
}
