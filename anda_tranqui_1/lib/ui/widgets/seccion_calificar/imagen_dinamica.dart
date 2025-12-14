import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagenDinamica extends StatefulWidget {
  const ImagenDinamica({
    super.key,
    this.imagenUrl,
    this.onImagenSeleccionada,
  });

  /// Path local o URL remota de imagen ya cargada
  final String? imagenUrl;

  /// Callback que devuelve el archivo seleccionado
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

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    setState(() {
      _imagenSeleccionada = file;
    });

    widget.onImagenSeleccionada?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    final Widget? imagen = _imagenSeleccionada != null
        ? Image.file(
            _imagenSeleccionada!,
            fit: BoxFit.cover,
          )
        : (widget.imagenUrl != null
            ? Image.network(
                widget.imagenUrl!,
                fit: BoxFit.cover,
              )
            : null);

    return InkWell(
      onTap: _subirImagen,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: imagen ??
              const Center(
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
