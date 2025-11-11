import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MetodoPagoYPrecio extends StatelessWidget {
  const MetodoPagoYPrecio({
    super.key,
    required this.metodoPago,
    required this.precio,
  });

  final List<String> metodoPago;
  final double precio;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textSize = screenWidth < 360 ? 14.0 : 16.0;

    final precioFormateado = NumberFormat.currency(
      locale: 'es_AR',
      symbol: '\$',
      decimalDigits: 2,
    ).format(precio);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            width: 28,
            height: 28,
            child: const Icon(
              Icons.attach_money,
              color: Colors.black,
              size: 22,
            ),
          ),
        ),
        Expanded(
          child: Text(
            '$metodoPago - $precioFormateado',
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.rubik(
              fontSize: textSize,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
