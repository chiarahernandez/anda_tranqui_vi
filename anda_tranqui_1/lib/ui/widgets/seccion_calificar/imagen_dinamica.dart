import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagenDinamica extends StatefulWidget {
  const ImagenDinamica({
    super.key,
    this.imagenUrl,
    this.onImagenSeleccionada,
  });

  /// URL o path de imagen ya cargada (si existe).
  final String? imagenUrl;

  /// Callback que devuelve el archivo seleccionado (si se sube uno).
  final ValueChanged<File>? onImagenSeleccionada;

  @override
  State<ImagenDinamica> createState() => _ImagenDinamicaState();
}

class _ImagenDinamicaState extends State<ImagenDinamica> {
  final ImagePicker _picker = ImagePicker();
  File? _imagenSeleccionada;

  Future<void> _subirImagen() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagenSeleccionada = File(pickedFile.path);
      });
      if (widget.onImagenSeleccionada != null) {
        widget.onImagenSeleccionada!(_imagenSeleccionada!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagenParaMostrar = _imagenSeleccionada != null
        ? Image.file(_imagenSeleccionada!)
        : (widget.imagenUrl != null
            ? Image.network(widget.imagenUrl!)
            : null);

    return InkWell(
      onTap: _subirImagen,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.0),
          child: imagenParaMostrar != null
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 160,
                    height: 160,
                    child: imagenParaMostrar,
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
        ),
      ),
    );
  }
}
