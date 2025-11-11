import 'package:flutter/material.dart';

//no gestiona estado interno: todos los datos se reciben desde afuera.
class Buscador extends StatelessWidget {
  final TextEditingController controller; //para leer lo que escribe
  final List<Map<String, dynamic>> sugerencias; //lista de sugerencias que se va a mostrar
  final void Function(Map<String, dynamic> sitio) onSeleccionar; //funcion que se va a ejecutar cuando se seleccione un sitio
  final VoidCallback onCerrar; //funcion que se va a ejecutar cuando se cierre el buscador

  //constructor
  const Buscador({
    super.key,
    required this.controller,
    required this.sugerencias,
    required this.onSeleccionar,
    required this.onCerrar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField( //campo de texto
          controller: controller, //le asocia el controlador que le pasemos
          decoration: InputDecoration( 
            hintText: 'Buscar sitio por nombre...', //placeholder
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(Icons.search, color: Color(0xFF4A949A)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xFF4A949A)),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.close, color: Colors.grey[600]),
              onPressed: onCerrar, //cuando apreta la cruz se usa la funcion oncerrar
            ),
          ),
        ),

        if (sugerencias.isNotEmpty) //si hay sugerencias
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4, // máximo 40% de la pantalla
            ),
            margin: EdgeInsets.only(top: 8),
            child: ListView.builder( //constructor de listas
              itemCount: sugerencias.length, //item count recibe len de sugerencias para ver cuando items tiene q mostrar
              itemBuilder: (context, index) { //funcion para construir cada item individualmente
                final sitio = sugerencias[index]; //agarramos el sitio correspondiente al index
                return ListTile( //widget para mostrar item (inluye ponerle icon creo asiq podriamos ponerele segun baño y agua)
                  title: Text(sitio['nombre'] ?? 'Sin nombre'), //muestra el nombre
                  onTap: () => onSeleccionar(sitio), //si lo tocan se ejecuta la funcion onseleccionary se le pasa el sitio
                );
              },
            ),
          ),
      ],
    );
  }
}
