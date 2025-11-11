import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotonFiltros extends StatefulWidget {
  final int? filtroActual;
  final Function(int?) onSeleccionar;

  const BotonFiltros({
    super.key,
    required this.filtroActual,
    required this.onSeleccionar,
  });

  @override
  State<BotonFiltros> createState() => _BotonFiltrosState();
}

class _BotonFiltrosState extends State<BotonFiltros> {
  bool _expandido = false;

  void _toggle() {
    setState(() {
      _expandido = !_expandido;
    });
  }

  Widget _botonPrincipal() {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        height: 36,
        constraints: const BoxConstraints(minWidth: 100, maxWidth: 180),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF4A949A),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          'Filtros',
          style: GoogleFonts.rubik(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _opcion(String texto, int? valor) {
    final bool seleccionado = widget.filtroActual == valor;
    return TextButton(
      onPressed: () {
        widget.onSeleccionar(valor);
        _toggle(); // Oculta al seleccionar
      },
      style: TextButton.styleFrom(
        backgroundColor: seleccionado
            ? const Color(0xFF4A949A)
            : const Color(0xFFB2D8DB), // más contraste
        foregroundColor: seleccionado ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(texto, style: const TextStyle(fontSize: 13)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxAncho = screenWidth * 0.9; // 90% del ancho disponible

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: _expandido
          ? Container(
              key: const ValueKey('expandido'),
              height: 36,
              constraints: BoxConstraints(maxWidth: maxAncho),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _opcion('Todos', null),
                    const SizedBox(width: 6),
                    _opcion('Baños', 1),
                    const SizedBox(width: 6),
                    _opcion('Agua', 2),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _toggle,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minHeight: 36, minWidth: 36),
                      splashRadius: 20,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            )
          : _botonPrincipal(),
    );
  }
}
