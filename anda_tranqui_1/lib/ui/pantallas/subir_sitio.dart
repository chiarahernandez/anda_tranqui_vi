import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../servicios/api_service.dart';
import 'package:latlong2/latlong.dart';
import 'dart:io';

import '../widgets/campo_tipo_sitio.dart';
import '../widgets/campo_nombre.dart';
import '../widgets/campo_horario.dart';
import '../widgets/campo_tipo_lugar.dart';
import '../widgets/campo_limpieza.dart';
import '../widgets/campo_precio.dart';
import '../widgets/campo_metodo.dart';
import '../widgets/campo_detalle.dart';
import '../widgets/cuadrito_switch.dart';
import '../widgets/boton_enviar.dart';
import '../widgets/alertas.dart';
import 'selector_ubicacion.dart';
import '../widgets/boton_ubicacion.dart';
import '../widgets/seccion_calificar/imagen_dinamica.dart';
class SubirSitioScreen extends StatefulWidget {
  final LatLng ubicacion;

  const SubirSitioScreen({super.key, required this.ubicacion});

  @override
  State<SubirSitioScreen> createState() => _SubirSitioScreenState();
}

class _SubirSitioScreenState extends State<SubirSitioScreen> {
  int? tipoSitioId;
  String? nombre;
  String? disponibilidad;
  Map<String, String?> horarios = {};
  int? tipoLugarId;
  int? limpieza;
  double? precio;
  List<int> metodosPago = [];
  bool esGratis = true;
  bool esAdaptado = false;
  String? detalle;
  late LatLng _ubicacionElegida; //guarda las coordenadas de la ubicacion elegida
  //late porque no podés inicializar _ubicacionElegida directamente al declararla, ya que necesitás acceder a widget.ubicacion para obtener su valor inicial, y eso no está disponible hasta que se ejecuta initState()
  //widget es una propiedad especial de los StatefulWidgets.
  //Dart no permite acceder a widget dentro del constructor del State, ni en el momento de la declaración de las variables.
  //Pero sí está accesible en initState() porque ahí el widget ya está montado correctamente.
  //Voy a declarar esta variable sin valor ahora, pero la voy a completar apenas el widget se inicialice, en initState()
  List<File> imagenesSubidas = []; //para guardar imagenes que suba

  @override
  void initState() { // initstate Es un método del ciclo de vida de un StatefulWidget. Se ejecuta una sola vez, cuando se construye el widget por primera vez.
    super.initState();
    _ubicacionElegida = widget.ubicacion; // por defecto la que le paso
    
  }

  //arma la lista de archivos
  void agregarImagen(String path) {
    setState(() {
      imagenesSubidas.add(File(path));
    });
  }

  void _guardar() async {
    final sitio = {
      'id_tipo_sitio': tipoSitioId,
      'nombre': nombre,
      'disponibilidad': disponibilidad,
      'horarios': horarios,
      'id_tipo_lugar': tipoLugarId,
      'limpieza': limpieza,
      'precio': esGratis ? null : precio,
      'metodos_pago': metodosPago,
      'es_adaptado': esAdaptado,
      'es_gratis': esGratis,
      'detalle': detalle,
      'latitud': _ubicacionElegida.latitude,
      'longitud': _ubicacionElegida.longitude,
    };

    try {
      await ApiService().subirSitio(sitio, imagenes: imagenesSubidas); //ahora le paso las imagenes ademas del sitio
      //alertas
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
            mensaje: 'Sitio cargado con éxito',
            onConfirmar: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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
            colorIcono: const Color(0xFFE89092),
            mensaje: 'Error al cargar el sitio',
            onConfirmar: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A949A), size: 35),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'Subir nuevo Sitio',
            style: GoogleFonts.rubik(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView( //creo que esto tiene una forma demasiado pesima de poner padding, los cuadrado esos sizedbox, no tiene pinta de ser muy óptimo
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tipo de Sitio
            CampoTipoSitio(
              valorSeleccionado: tipoSitioId,
              onChanged: (val) => setState(() => tipoSitioId = val),
            ),

            const SizedBox(height: 24),

            // Nombre
            CampoNombre(
              valorInicial: nombre,
              onChanged: (val) => setState(() => nombre = val),
            ),

            const SizedBox(height: 24),
            //ubicación
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: BotonUbicacion(
                onPressed: () async { //cuando lo clickean,,,  async porque adentro se espera el resultado de otra pantalla

                //no se si esto hay q ponerlo en las rutas en el main(?)
                  final nuevaUbicacion = await Navigator.push( //va a guardar la nueva ubicacion pero espera el resultado de la pantalla
                    context,
                    MaterialPageRoute( //transición
                      builder: (context) => SelectorUbicacionScreen( //construye la pnatalla
                        ubicacionInicial: _ubicacionElegida, //la pantalla recibe la ubicacion actual para poner por default
                      ),
                    ),
                  );

                  if (nuevaUbicacion != null && mounted) { //si hay ubicación
                    setState(() {
                      _ubicacionElegida = nuevaUbicacion; //se reemplaza la anterior
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 24),

            // Switches
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CuadritoSwitchWidget(
                    texto: 'Gratis',
                    valor: esGratis,
                    onChanged: (val) => setState(() => esGratis = val),
                  ),
                  CuadritoSwitchWidget(
                    texto: 'Apto',
                    valor: esAdaptado,
                    onChanged: (val) => setState(() => esAdaptado = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Horario
            CampoHorario(
              titulo: 'Horario de atención',
              onChanged: (map) => setState(() => horarios = map),
            ),

            const SizedBox(height: 24),

            // Tipo de Lugar
            CampoTipoLugar(
              valores: const [1, 2, 3, 4],
              etiquetas: const ['Espacio Público', 'Tienda', 'Café', 'Gasolinera'],
              valorSeleccionado: tipoLugarId,
              onChanged: (val) => setState(() => tipoLugarId = val),
            ),

            const SizedBox(height: 24),

            // Limpieza
             CampoLimpieza(
              valorSeleccionado: limpieza,
              onChanged: (val) => setState(() => limpieza = val),
            ),

            const SizedBox(height: 24),

            // Precio y métodos si NO es gratis
            if (!esGratis) ...[
              CampoPrecioWidget(
                valorInicial: precio,
                onChanged: (val) => setState(() => precio = val),
              ),
              const SizedBox(height: 16),
              CampoMetodoWidget(
                metodosSeleccionados: metodosPago,
                onChanged: (lista) => setState(() => metodosPago = lista),
              ),
              const SizedBox(height: 24),
            ],

            // Detalles
            CampoDetalle(
              maxLength: 300,
              valorInicial: detalle,
              onChanged: (val) => setState(() => detalle = val),
            ),

            const SizedBox(height: 32),

            // Imágenes 
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...imagenesSubidas.map(
                      (file) => Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: ImagenDinamica(imagenUrl: file.path),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: ImagenDinamica(
                        onImagenSeleccionada: (archivo) {
                          agregarImagen(archivo.path);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Botón enviar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: BotonEnviar(
                texto: 'Enviar',
                onPressed: _guardar,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
