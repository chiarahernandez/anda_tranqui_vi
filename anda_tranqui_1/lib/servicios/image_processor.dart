import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Se ejecuta en isolate (compute)
Future<Uint8List> procesarYComprimirImagen(File imagen) async {
  // 1️⃣ Leer bytes originales
  final bytesOriginales = await imagen.readAsBytes();

  // 2️⃣ Decodificar imagen
  final imagenDecodificada = img.decodeImage(bytesOriginales);
  if (imagenDecodificada == null) {
    // fallback: devolver original si algo falla
    return bytesOriginales;
  }

  // 3️⃣ Redimensionar si es muy grande
  const maxLado = 1600;
  img.Image imagenFinal = imagenDecodificada;

  if (imagenDecodificada.width > maxLado ||
      imagenDecodificada.height > maxLado) {
    imagenFinal = img.copyResize(
      imagenDecodificada,
      width: imagenDecodificada.width >= imagenDecodificada.height
          ? maxLado
          : null,
      height: imagenDecodificada.height > imagenDecodificada.width
          ? maxLado
          : null,
    );
  }

  // 4️⃣ Re-encode JPEG con calidad controlada
  final bytesComprimidos = img.encodeJpg(
    imagenFinal,
    quality: 80, // equilibrio peso / calidad
  );

  // 5️⃣ Devolver bytes finales
  return Uint8List.fromList(bytesComprimidos);
}
