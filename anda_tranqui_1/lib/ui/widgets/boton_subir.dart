import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../pantallas/subir_sitio.dart';

class BotonSubir extends StatelessWidget {
  final LatLng? ubicacion;
  final VoidCallback? onSitioCreado;

  const BotonSubir({
    super.key,
    required this.ubicacion,
    this.onSitioCreado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF4A949A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: () async {
          if (ubicacion != null) {
            final bool? sitioCreado = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SubirSitioScreen(ubicacion: ubicacion!),
              ),
            );

            if (sitioCreado == true) {
              onSitioCreado?.call();
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ubicación no disponible")),
            );
          }
        },
        icon: const Icon(
          Icons.add,
          size: 35,
          color: Colors.white,
        ),
        splashRadius: 28,
        tooltip: 'Subir sitio',
      ),
    );
  }
}
