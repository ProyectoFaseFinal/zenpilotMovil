// importación de paquetes y librerias de flutter
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SmartwatchService {
  // obtenemos la variable de entorno para la URL base de la api en .ENV
  final baseUrlApi = dotenv.env['API_BASE_URL'] ?? '';
  //--------------------------------
  // Metodo Get para obtener la información del usuario
  //--------------------------------
  Future<List<dynamic>> getSmartwatch() async {
    // Aquí vamos a construir el EndPoint completo
    final String urlCompleta = '$baseUrlApi/api/smartwatch';
    //try catch para manejar errores en la solicitud HTTP
    try {
      final result = await http.get(Uri.parse(urlCompleta));
      if (result.statusCode == 200) {
        final deCodeDataAbout = jsonDecode(result.body);
        print('Datos obtenidos de la API: $deCodeDataAbout');
        return deCodeDataAbout;
      } else {
        print('Error al obtener los datos de smartwatch: ${result.statusCode} - ${result.body}');
        throw Exception('Error al obtener los datos de smartwatch: ${result.statusCode}');
      }
    } catch (e) {
      print('Error al obtener los datos de smartwatch');
      throw Exception('Error al obtener los datos de smartwatch, error: $e');
    }
  }
  //--------------------------------
  // Metodo Post para obtener la información del usuario
  //--------------------------------
  Future<bool> postSmartwatch(int idUser, int frecuenciaCardiaca, int velocidadPromedio, String name) async {
    //Construcción del EndPoint Completa
    final String urlCompleta = '$baseUrlApi/api/smartwatch';
    try {
      final result = await http.post(
        Uri.parse(urlCompleta),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "idUser": idUser,
          "frecuencia_cardiaca": frecuenciaCardiaca,
          "velocidad_promedio": velocidadPromedio,
          "name": name
        })
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        print("Datos guardado exitosamente");
        return true;
      } else {
        print('Error al crear el smartwatch del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error a tratar de crear el smartwatch del usuario');
      throw Exception('Error a tratar de crear el post del usuariio: $e');
    }
  }
  //--------------------------------
  // Metodo Put para obtener la información del usuario
  //--------------------------------
  // En smartwatch_service.dart
  Future<bool> putSmartwatch({
    required int id,
    int? frecuenciaCardiaca,
    int? velocidadPromedio,
    String? name,
  }) async {
    final String urlCompleta = '$baseUrlApi/api/smartwatch/$id';
    try {
      final body = {
        if (frecuenciaCardiaca != null) "frecuencia_cardiaca": frecuenciaCardiaca,
        if (velocidadPromedio != null) "velocidad_promedio": velocidadPromedio,
        if (name != null) "name": name,
      };

      final result = await http.put(
        Uri.parse(urlCompleta),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (result.statusCode == 200) {
        print('Datos actualizados con éxito');
        return true;
      } else {
        print('Error al actualizar el smartwatch: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error al actualizar el smartwatch: $e');
      return false;
    }
  }
  //---------------------------------------
  // Metodo delete para crear un nuevo usuario
  //---------------------------------------
  Future<bool> deleteSmartwatch(int id) async {
    final String urlCompleta = '$baseUrlApi/api/smartwatch/$id';
    try {
      final result = await http.delete(Uri.parse(urlCompleta));
      if (result.statusCode == 200) {
        print('Datos eliminados exitosamente');
        return true;
      } else {
        print('Error al eliminar el smartwatch del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error a tratar de eliminar el smartwatch del usuario');
      throw Exception('Error a tratar de eliminar el smartwatch del usuario: $e');
    }
  }
}