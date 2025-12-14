import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List> procesarYComprimirImagen(File imagen) async {
  final bytesOriginales = await imagen.readAsBytes();
  final original = img.decodeImage(bytesOriginales);
  if (original == null) return bytesOriginales;

  // 1️⃣ Recorte cuadrado centrado
  final lado = original.width < original.height
      ? original.width
      : original.height;

  final x = (original.width - lado) ~/ 2;
  final y = (original.height - lado) ~/ 2;

  final cuadrada = img.copyCrop(
    original,
    x: x,
    y: y,
    width: lado,
    height: lado,
  );

  // 2️⃣ Resize final
  final finalImg = img.copyResize(
    cuadrada,
    width: 1600,
    height: 1600,
  );

  // 3️⃣ Compresión
  final jpg = img.encodeJpg(finalImg, quality: 80);

  return Uint8List.fromList(jpg);
}
