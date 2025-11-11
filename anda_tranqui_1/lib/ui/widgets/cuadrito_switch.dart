import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CuadritoSwitchWidget extends StatelessWidget {
  const CuadritoSwitchWidget({
    super.key,
    required this.texto,
    required this.valor,
    required this.onChanged,
  });

  final String texto;
  final bool valor;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      height: 165,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            texto,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Switch.adaptive(
            value: valor,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF4A949A),
            inactiveTrackColor: const Color(0xFF5C5C5C),
            inactiveThumbColor: Theme.of(context).colorScheme.surface,
          ),
        ],
      ),
    );
  }
}
