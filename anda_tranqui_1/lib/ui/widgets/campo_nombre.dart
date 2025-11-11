import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampoNombre extends StatefulWidget {
  final TextEditingController? controller;
  final String? valorInicial;
  final void Function(String)? onChanged;

  const CampoNombre({
    super.key,
    this.controller,
    this.valorInicial,
    this.onChanged,
  });

  @override
  State<CampoNombre> createState() => _CampoNombreState();
}

class _CampoNombreState extends State<CampoNombre> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.valorInicial ?? '');
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nombre',
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.45,
              child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: widget.onChanged,
                maxLength: 30,
                decoration: InputDecoration(
                  hintText: 'Ingresar nombre del sitio',
                  hintStyle: GoogleFonts.rubik(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.6),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  counterText: '', // elimina el contador de caracteres
                ),
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
