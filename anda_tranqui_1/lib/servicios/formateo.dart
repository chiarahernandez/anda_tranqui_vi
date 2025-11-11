import 'package:flutter/material.dart';

/// Parsea una hora en formato "HH:mm" a TimeOfDay
TimeOfDay? parseTime(String? s) {
  if (s == null || s.isEmpty) return null;
  final parts = s.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return TimeOfDay(hour: h, minute: m);
}

/// Parsea un valor dinámico a double para representar el rating
double parseRating(dynamic rawRating) {
  if (rawRating is double) return rawRating;
  if (rawRating is int) return rawRating.toDouble();
  if (rawRating is String) return double.tryParse(rawRating) ?? 0.0;
  return 0.0;
}

/// Parsea un string de imágenes separadas por coma a una lista de strings
List<String> parseImagenes(String? rawImgs) {
  if (rawImgs == null || rawImgs.isEmpty) return [];
  return rawImgs.split(',').map((s) => s.trim()).toList();
}