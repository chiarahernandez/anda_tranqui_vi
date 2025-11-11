import 'package:flutter/material.dart';

class CampoLimpieza extends StatelessWidget {
  final int? valorSeleccionado;
  final void Function(int?) onChanged;

  const CampoLimpieza({
    super.key,
    required this.valorSeleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final valores = [1, 2, 3, 4, 5];
    final etiquetas = ['Excelente', 'Buena', 'Regular', 'Mala', 'Muy mala'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Limpieza',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<int>(
              value: valorSeleccionado,
              onChanged: onChanged,
              items: List.generate(valores.length, (index) {
                return DropdownMenuItem<int>(
                  value: valores[index],
                  child: Text(etiquetas[index]),
                );
              }),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
