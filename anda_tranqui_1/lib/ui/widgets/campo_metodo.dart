import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampoMetodoWidget extends StatefulWidget {
  const CampoMetodoWidget({
    super.key,
    this.metodosSeleccionados,
    required this.onChanged,
  });

  /// Lista de enteros que representan métodos seleccionados
  final List<int>? metodosSeleccionados;
  final void Function(List<int>) onChanged;

  @override
  State<CampoMetodoWidget> createState() => _CampoMetodoWidgetState();
}

class _CampoMetodoWidgetState extends State<CampoMetodoWidget> {
  final List<String> _opciones = ['Efectivo', 'Transferencia', 'Crédito', 'Débito'];
  late List<bool> _seleccionados;

  @override
  void initState() {
    super.initState();
    _seleccionados = List.generate(
      _opciones.length,
      (index) => widget.metodosSeleccionados?.contains(index + 1) ?? false,
    );
  }

  void _toggleSeleccion(int index) {
    setState(() {
      _seleccionados[index] = !_seleccionados[index];
    });

    final seleccionados = <int>[];
    for (int i = 0; i < _seleccionados.length; i++) {
      if (_seleccionados[i]) {
        seleccionados.add(i + 1); // Guardamos como 1, 2, 3, 4
      }
    }

    widget.onChanged(seleccionados);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Métodos de pago',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(_opciones.length, (index) {
              final seleccionado = _seleccionados[index];
              return FilterChip(
                label: Text(
                  _opciones[index],
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: seleccionado ? Colors.white : Colors.black,
                  ),
                ),
                selected: seleccionado,
                onSelected: (_) => _toggleSeleccion(index),
                selectedColor: Colors.black,
                backgroundColor: Colors.grey.shade200,
                checkmarkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
