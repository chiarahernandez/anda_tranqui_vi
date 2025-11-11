import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

/// modelo de horario diario
typedef DailySchedule = Map<String, TimeOfDay?>; // {'start': TimeOfDay, 'end': TimeOfDay}

class InfoHorario extends StatelessWidget {
  /// Mapa de horarios por día: claves en español 'Lunes', 'Martes', etc.
  /// Cada entrada tiene un mapa con 'start' y 'end' como TimeOfDay? (null = cerrado)
  final Map<String, DailySchedule> schedule;

  const InfoHorario({
    super.key,
    required this.schedule,
  });

  bool get _all24Hours {
    // Chequea si cada día está abierto 00:00-23:59
    return schedule.values.every((day) {
      final start = day['start'];
      final end = day['end'];
      return start != null && end != null &&
        start.hour == 0 && start.minute == 0 &&
        end.hour == 23 && end.minute == 59;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_all24Hours) {
      return Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(
              FontAwesomeIcons.clock,
              color: Colors.black,
              size: 24,
            ),
          ),
          Text(
            'Abierto 24 horas',
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    return ExpansionTile(
      leading: const Icon(
        FontAwesomeIcons.clock,
        color: Colors.black,
        size: 24,
      ),
      title: Text(
        'Horarios',
        style: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: const EdgeInsets.only(left: 72, right: 16, bottom: 8),
      children: schedule.entries.map((entry) {
        final day = entry.key;
        final start = entry.value['start'];
        final end = entry.value['end'];
        final text = (start != null && end != null)
            ? '${_formatTime(start)} - ${_formatTime(end)}'
            : 'Cerrado';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day,
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                text,
                style: GoogleFonts.rubik(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
