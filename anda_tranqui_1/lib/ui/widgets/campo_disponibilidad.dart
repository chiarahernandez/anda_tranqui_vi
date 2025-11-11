import 'package:flutter/material.dart';

class CampoDisponibilidad extends StatefulWidget {
  final String? initialValue;
  final void Function(String?)? onChanged;

  const CampoDisponibilidad({
    Key? key,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CampoDisponibilidad> createState() => _CampoDisponibilidadState();
}

class _CampoDisponibilidadState extends State<CampoDisponibilidad> {
  String? selectedValue;

  final List<Map<String, String>> opciones = [
    {'label': 'Disponible', 'value': '1'},
    {'label': 'No disponible', 'value': '2'},
  ];

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Disponibilidad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.45,
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                isExpanded: true,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: opciones.map((opcion) {
                  return DropdownMenuItem<String>(
                    value: opcion['value'],
                    child: Text(opcion['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
