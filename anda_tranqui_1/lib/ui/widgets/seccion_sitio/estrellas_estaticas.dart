import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class EstrellasEstaticas extends StatelessWidget {
  const EstrellasEstaticas({
    super.key,
    required this.valor,
  });

  final double valor; // de 0.0 a 5.0

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: valor.clamp(0.0, 5.0),
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Color(0xFFEEE86B),
      ),
      itemCount: 5,
      itemSize: 30, // mantené el tamaño visual deseado
      unratedColor: Color(0xFFD9D9D9),
      direction: Axis.horizontal,
    );
  }
}
