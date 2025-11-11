import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampoPrecioWidget extends StatefulWidget {
  const CampoPrecioWidget({
    super.key,
    this.valorInicial,
    required this.onChanged,
  });

  final double? valorInicial;
  final void Function(double?) onChanged;

  @override
  State<CampoPrecioWidget> createState() => _CampoPrecioWidgetState();
}

class _CampoPrecioWidgetState extends State<CampoPrecioWidget> {
  late TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.valorInicial != null ? widget.valorInicial.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.'));

    setState(() {
      if (value.trim().isEmpty) {
        _error = 'Ingrese un precio';
        widget.onChanged(null);
      } else if (parsed == null || parsed < 0) {
        _error = 'Valor inválido';
        widget.onChanged(null);
      } else {
        _error = null;
        widget.onChanged(parsed);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Precio (en pesos argentinos)',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: _handleChanged,
            decoration: InputDecoration(
              hintText: 'Ej: 100.0 o 0 (a voluntad)',
              filled: true,
              fillColor: Colors.white,
              errorText: _error,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
            style: GoogleFonts.rubik(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
