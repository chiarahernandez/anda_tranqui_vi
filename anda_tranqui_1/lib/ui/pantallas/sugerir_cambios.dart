
import 'package:flutter/material.dart';
import '../../servicios/api_service.dart';

import '../widgets/campo_disponibilidad.dart';
import '../widgets/campo_horario.dart';
import '../widgets/campo_tipo_lugar.dart';
import '../widgets/campo_limpieza.dart';
import '../widgets/campo_precio.dart';
import '../widgets/campo_metodo.dart';
import '../widgets/cuadrito_switch.dart';
import '../widgets/spot.dart';
import '../widgets/tipo_lugar.dart';
import '../widgets/boton_enviar.dart';
import '../widgets/alertas.dart';

class SugerirCambiosScreen extends StatefulWidget {
  const SugerirCambiosScreen({
    Key? key,
    required this.nombreSpot,
    required this.tipoTexto,
    required this.idTipoSitio,
    required this.idSitio,
  }) : super(key: key);

  final String nombreSpot;
  final String tipoTexto;
  final int idSitio; // ID del sitio al que se le sugieren cambios
  final int idTipoSitio; // ID del tipo de sitio para sugerir cambios

  @override
  State<SugerirCambiosScreen> createState() => _SugerirCambiosScreenState();
}

class _SugerirCambiosScreenState extends State<SugerirCambiosScreen> {
  // Estado de cada campo para dsp mandarlos a bdd
  int? tipoLugarId;
  String? spotNombre;
  String? disponibilidad;
  Map<String, String?> horarios = {};
  int? limpieza;
  double? precio;
  List<int> metodosPago = [];
  bool esAdaptado = true;
  bool esGratis = true;

 void _guardar() async {
  final sugerencia = {
    'id_sitio': widget.idSitio,
    'id_tipo_sitio': widget.idTipoSitio,
    'id_tipo_lugar': tipoLugarId,
    'id_limpieza': limpieza,
    'id_disponibilidad': disponibilidad, 
    'precio': esGratis ? null : precio,
    'metodos_pago': metodosPago,
    'gratis': esGratis,
    'adaptable': esAdaptado,
    // Horarios diarios
    'lunes_inicio': horarios['lunes_inicio'],
    'lunes_fin': horarios['lunes_fin'],
    'martes_inicio': horarios['martes_inicio'],
    'martes_fin': horarios['martes_fin'],
    'miercoles_inicio': horarios['miercoles_inicio'],
    'miercoles_fin': horarios['miercoles_fin'],
    'jueves_inicio': horarios['jueves_inicio'],
    'jueves_fin': horarios['jueves_fin'],
    'viernes_inicio': horarios['viernes_inicio'],
    'viernes_fin': horarios['viernes_fin'],
    'sabado_inicio': horarios['sabado_inicio'],
    'sabado_fin': horarios['sabado_fin'],
    'domingo_inicio': horarios['domingo_inicio'],
    'domingo_fin': horarios['domingo_fin'],
  };

  try {
    await ApiService().subirSugerencia(sugerencia);
    print('Sugerencia enviada: $sugerencia');
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: AlertaWidget(
          icono: Icons.check_circle_outline_rounded,
          colorIcono: const Color(0xFFB2D8C3),
          mensaje: 'Sugerencia cargada con éxito',
          onConfirmar: () {
            Navigator.of(context).pop(); // cierra alerta
            Navigator.of(context).pop(); // vuelve atrás
          },
        ),
      ),
    );
  } catch (e) {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: AlertaWidget(
          icono: Icons.error_outline,
          colorIcono: const Color(0xFFF8B5B5),
          mensaje: 'Error al subir la sugerencia',
          onConfirmar: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Sugerir cambios en el sitio',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           // Icono y tipo actual
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
              child: TipoSitio(
                texto: widget.tipoTexto,
                idTipoSitio: widget.idSitio, 
              ),
            ),

            // Nombre del spot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              child: Spot(texto: widget.nombreSpot),
            ),
            const SizedBox(height: 12),
            // Disponibilidad
            CampoDisponibilidad(
              initialValue: disponibilidad,
              onChanged: (val) => setState(() => disponibilidad = val),
            ),
            // Switches: Gratis y Adaptado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CuadritoSwitchWidget(
                    texto: 'Gratis',
                    valor: esGratis,
                    onChanged: (val) => setState(() => esGratis = val),
                  ),
                  CuadritoSwitchWidget(
                    texto: 'Apto para personas con discapacidad',
                    valor: esAdaptado,
                    onChanged: (val) => setState(() => esAdaptado = val),
                  ),
                ],
              ),
            ),
            // Horario
            CampoHorario(
              titulo: 'Horario de atención',
              onChanged: (hMap) => setState(() => horarios = hMap),
            ),
            // Tipo de lugar (dropdown para sugerir otro tipo)
            CampoTipoLugar(
              valores: const [1, 2, 3, 4],
              etiquetas: const ['Espacio Público', 'Tienda', 'Café', 'Gasolinera'],
              valorSeleccionado: tipoLugarId,
              onChanged: (val) => setState(() => tipoLugarId = val),
            ),
            // Limpieza
            CampoLimpieza(
              valorSeleccionado: limpieza,
              onChanged: (val) => setState(() => limpieza = val),
            ),
            // Precio y métodos (solo si no es gratis)
            if (!esGratis) ...[
              CampoPrecioWidget(
                valorInicial: precio,
                onChanged: (val) => setState(() => precio = val),
              ),
              CampoMetodoWidget(
                metodosSeleccionados: metodosPago,
                onChanged: (lista) => setState(() => metodosPago = lista),
              ),
            ],
            const SizedBox(height: 24),
            // Botón Enviar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: BotonEnviar(
                texto: 'Enviar',
                onPressed: _guardar,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
