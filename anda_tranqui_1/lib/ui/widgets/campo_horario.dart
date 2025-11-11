import 'package:flutter/material.dart';

class CampoHorario extends StatefulWidget {
  final String titulo;
  final void Function(Map<String, String?>) onChanged;

  const CampoHorario({
    super.key, // <-- mejora sugerida: uso de super parameter
    this.titulo = 'Horario',
    required this.onChanged,
  });

  @override
  State<CampoHorario> createState() => _CampoHorarioState();
}

class _CampoHorarioState extends State<CampoHorario> {
  bool abierto24hs = false;

  final Map<String, TimeOfDayRange?> horariosPorDia = {
    'Lunes': null,
    'Martes': null,
    'Miércoles': null,
    'Jueves': null,
    'Viernes': null,
    'Sábado': null,
    'Domingo': null,
  };

  Future<void> _seleccionarHorario(BuildContext context, String dia) async {
    final apertura = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (!mounted || apertura == null) return; // <-- corrección del uso de context async

    final cierre = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );
    if (!mounted || cierre == null) return;

    setState(() => horariosPorDia[dia] = TimeOfDayRange(start: apertura, end: cierre));
    widget.onChanged(_getHorariosMapPlano());
  }

  void _toggle24hs(bool value) {
    setState(() {
      abierto24hs = value;
      if (value) {
        horariosPorDia.updateAll(
          (key, _) => const TimeOfDayRange(
            start: TimeOfDay(hour: 0, minute: 0),
            end: TimeOfDay(hour: 23, minute: 59),
          ),
        );
      } else {
        horariosPorDia.updateAll((_, __) => null);
      }
    });
    widget.onChanged(_getHorariosMapPlano());
  }

  Map<String, String?> _getHorariosMapPlano() {
    const dias = {
      'Lunes': 'lunes',
      'Martes': 'martes',
      'Miércoles': 'miercoles',
      'Jueves': 'jueves',
      'Viernes': 'viernes',
      'Sábado': 'sabado',
      'Domingo': 'domingo',
    };

    final Map<String, String?> resultado = {};

    for (final entry in dias.entries) {
      final keyFlutter = entry.key;
      final keyApi = entry.value;
      final rango = horariosPorDia[keyFlutter];

      resultado['${keyApi}_inicio'] = rango != null ? _formatHora(rango.start) : null;
      resultado['${keyApi}_fin'] = rango != null ? _formatHora(rango.end) : null;
    }

    return resultado;
  }

  String _formatHora(TimeOfDay hora) {
    return '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Abierto 24 hs todos los días'),
              value: abierto24hs,
              onChanged: _toggle24hs,
            ),
            const Divider(),
            ...horariosPorDia.keys.map((dia) {
              final rango = horariosPorDia[dia];
              return ListTile(
                title: Text(dia),
                subtitle: Text(
                  rango == null ? 'Cerrado' : '${rango.start.format(context)} - ${rango.end.format(context)}',
                ),
                trailing: const Icon(Icons.schedule),
                onTap: abierto24hs ? null : () => _seleccionarHorario(context, dia),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class TimeOfDayRange {
  final TimeOfDay start;
  final TimeOfDay end;

  const TimeOfDayRange({required this.start, required this.end});
}
