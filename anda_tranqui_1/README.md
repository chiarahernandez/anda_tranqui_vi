# anda_tranqui

Este proyecto corresponde a una aplicación móvil desarrollada en Flutter que permite localizar baños públicos y puestos de agua potable en la ciudad de Mendoza.
La aplicación muestra los sitios en un mapa interactivo, permite filtrarlos por tipo, visualizar información detallada y que los usuarios carguen nuevos lugares con fotos, horarios y calificaciones.

Características principales

- Mapa interactivo con OpenStreetMap.

- Filtros para mostrar únicamente baños o puestos de agua.

-Búsqueda por nombre con sugerencias.

-Subida de nuevos sitios con imágenes, ubicación ajustable y horarios personalizados.

-Sistema de calificación y comentarios.

-Conexión con Supabase para la gestión de datos e imágenes.

----Requisitos previos----

Flutter SDK instalado (versión 3.0 o superior recomendada).

Android Studio o Visual Studio Code configurado con soporte para Flutter.

Un dispositivo físico Android o un emulador configurado.

----Ejecución del proyecto----
----Opción 1: Ejecutar en un dispositivo físico

Clonar este repositorio:
git clone https://github.com/usuario/nombre-del-repo.git


Abrir el proyecto en Android Studio o VS Code.
Una vez clonado el proyecto, ejecutar flutter pub get para instalar las dependencias.

Conectar el dispositivo Android mediante USB y habilitar la depuración USB.

Ejecutar el proyecto:
flutter run


La aplicación se instalará y abrirá en el dispositivo conectado.

----Opción 2: Ejecutar en un emulador

Crear un emulador desde AVD Manager (por ejemplo, Pixel 5 con Android 13).

Iniciar el emulador.

Desde la terminal del proyecto, ejecutar:

flutter run

La aplicación se iniciará dentro del emulador.