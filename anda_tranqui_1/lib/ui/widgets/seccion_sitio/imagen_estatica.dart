import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    final ancho = screenWidth * 0.45;
    final alto = ancho;

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
            ? CachedNetworkImage(
                imageUrl: url!,
                width: ancho,
                height: alto,
                fit: BoxFit.cover,

                // mientras carga
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),

                // si falla
                errorWidget: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                ),

                // optimización → precarga
                memCacheWidth: 600,
                memCacheHeight: 600,
              )
            : const Center(
                child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              ),
      ),
    );
  }
}
