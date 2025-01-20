import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BDConnections {
  static const String UriUp = "http://192.168.0.54/Libros/upload.php";
  static final Uri upload = Uri.parse(UriUp);

  // Insertar datos
  Future<void> cargarLibro(File portadaPath, String titulo, String autor,
      String descripcion, File libroPath) async {
    try {
      // Leer los archivos como bytes
      List<int> portadaBytes = await portadaPath.readAsBytes();
      List<int> libroBytes = await libroPath.readAsBytes();

      // Verificar que los archivos no estén vacíos
      if (portadaBytes.isEmpty || libroBytes.isEmpty) {
        print("Error: Uno de los archivos está vacío.");
        return;
      }

      // Convertir los archivos a base64
      String portadaBase64 = base64Encode(portadaBytes);
      String libroBase64 = base64Encode(libroBytes);

      // Crear el cuerpo de la solicitud en formato JSON
      var body = jsonEncode({
        'titulo': titulo,
        'autor': autor,
        'descripcion': descripcion,
        'portada': portadaBase64,
        'libro': libroBase64,
      });

      var response = await http.post(
        upload,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        print('Libro cargado exitosamente');
      } else {
        print('Error al cargar el libro: ${response.body}');
      }
    } catch (e) {
      print("Error al cargar el libro: $e");
    }
  }
}
