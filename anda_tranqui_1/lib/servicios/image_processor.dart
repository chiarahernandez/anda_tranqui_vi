import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

Future<Uint8List> procesarYComprimirImagen(File imagen) async {
  final bytes = await imagen.readAsBytes();
  
  return bytes; 
}