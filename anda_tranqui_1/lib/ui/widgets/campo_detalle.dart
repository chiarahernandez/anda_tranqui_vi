import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampoDetalle extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String label;
  final int maxLength;
  final String? valorInicial;
  final void Function(String)? onChanged;

  const CampoDetalle({
    super.key,
    this.controller,
    this.focusNode,
    this.label = 'Detalles',
    this.maxLength = 300,
    this.valorInicial,
    this.onChanged,
  });

  @override
  State<CampoDetalle> createState() => _CampoDetalleState();
}

class _CampoDetalleState extends State<CampoDetalle> {
  late final TextEditingController _controller;
  FocusNode? _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.valorInicial ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              maxLength: widget.maxLength,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Ingresar detalle',
                hintStyle: GoogleFonts.rubik(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                border: InputBorder.none,
                counterText: '',
              ),
              style: GoogleFonts.rubik(
                fontSize: 16,
                color: Colors.black,
              ),
              cursorColor: Colors.black,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
