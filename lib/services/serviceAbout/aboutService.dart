// importación de paquetes y librerias de flutter
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AboutService {
  // obtenemos la variable de entorno para la URL base de la api en .ENV
  final baseUrlApi = dotenv.env['API_BASE_URL'] ?? '';
  //--------------------------------
  // Metodo Get para obtener la información del usuario
  //--------------------------------
  Future<List<dynamic>> getAbout() async {
    // Aquí vamos a construir el EndPoint completo
    final String urlCompleta = '$baseUrlApi/api/about';
    //try catch para manejar errores en la solicitud HTTP
    try {
      final result = await http.get(Uri.parse(urlCompleta));
      if (result.statusCode == 200) {
        final deCodeDataAbout = jsonDecode(result.body);
        print('Datos obtenidos de la API: $deCodeDataAbout');
        return deCodeDataAbout['data'];
      } else {
        print('Error al obtener los datos de about: ${result.statusCode} - ${result.body}');
        throw Exception('Error al obtener los datos de about: ${result.statusCode}');
      }
    } catch (e) {
      print('Error al obtener los datos de about');
      throw Exception('Error al obtener los datos de about, error: $e');
    }
  }
  //--------------------------------
  // Metodo Post para obtener la información del usuario
  //--------------------------------
  Future<bool> postAbout(String nombre, int edad) async {
    //Construcción del EndPoint Completa
    final String urlCompleta = '$baseUrlApi/api/about';
    try {
      final result = await http.post(
        Uri.parse(urlCompleta),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "nombre": nombre,
          "edad": edad
        })
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        print("Datos guardado exitosamente");
        return true;
      } else {
        print('Error al crear el about del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error a tratar de crear el about del usuario');
      throw Exception('Error a tratar de crear el post del usuariio: $e');
    }
  }
  //--------------------------------
  // Metodo Put para obtener la información del usuario
  //--------------------------------
  Future<bool> putAbout(int id, String nombre, int edad) async {
    final String urlCompleta = '$baseUrlApi/api/about/$id';
    try {
      final result = await http.put(
        Uri.parse(urlCompleta),
        headers: {
          'Content-Type': 'application/json'
        },
        body: {
          "userId": id,
          "nombre": nombre,
          "edad": edad
        }
      );
      if (result.statusCode == 200) {
        print('Datos actualizados con exito');
        return true;
      } else {
        print('Error al actualizar el about del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error a tratar de actualizar el about del usuario');
      throw Exception ('Error a tratar de actualizar el about del usaurio: $e');
    }
  }
  //---------------------------------------
  // Metodo delete para crear un nuevo usuario
  //---------------------------------------
  Future<bool> deleteAbout(int id) async {
    final String urlCompleta = '$baseUrlApi/api/about/$id';
    try {
      final result = await http.delete(Uri.parse(urlCompleta));
      if (result.statusCode == 200) {
        print('Datos eliminados exitosamente');
        return true;
      } else {
        print('Error al eliminar el about del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error a tratar de eliminar el about del usuario');
      throw Exception('Error a tratar de eliminar el about del usuario: $e');
    }
  }
}