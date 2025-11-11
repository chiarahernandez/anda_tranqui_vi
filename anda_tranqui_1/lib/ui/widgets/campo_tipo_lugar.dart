import 'package:flutter/material.dart';

class CampoTipoLugar extends StatelessWidget {
  final String titulo;
  final List<int> valores; // Ej: [1, 2, 3]
  final List<String> etiquetas; // Ej: ['Espacio Público', 'Tienda', ...]
  final int? valorSeleccionado;
  final void Function(int?) onChanged;

  const CampoTipoLugar({
    super.key,
    this.titulo = 'Tipo de lugar',
    required this.valores,
    required this.etiquetas,
    required this.valorSeleccionado,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
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
