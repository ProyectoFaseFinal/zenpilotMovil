import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthServiceLogin {
  // obtener la variable de entorno para la URL base de la API
  final String _apiBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
  //-------------------------------
  // Metodo Get para iniciar sesión
  //-------------------------------
  Future<List<dynamic>> obtenerUsuarios() async {
    //construir la url completa del endpoint usuarios
    final String urlCompleta = '$_apiBaseUrl/api/usuarios';
    print('URL completa del endpoint: $urlCompleta');
    try {
      //ejecutar la solicitud GET a la API con http
      final response = await http.get(Uri.parse(urlCompleta));
      if (response.statusCode == 200) {
        //si es 200 entonces paso a decodificar datos que esta en un json a un objeto
        final deCodeData = jsonDecode(response.body);
        print('Datos obtenidos de la API: $deCodeData');
        //retornar los datos obtenido de la API
        return deCodeData['data'];
      } else {
        print('Error al obtener los datos: ${response.statusCode} - ${response.body}');
        throw Exception('Error al obtener los datos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener los datos: $e');
      throw Exception('Error al obtener los datos: $e');
    }
  }
  //---------------------------------------
  // Metodo put para crear un nuevo usuario
  //---------------------------------------
  Future<bool> crearUsuario(String email, String password, String name) async {
    //Completamos la URL del endpoint
    final String urlCompleta ='$_apiBaseUrl/api/usuarios';
    print('URL completa del endpoint: $urlCompleta');
    try {
      //Ejejcutar la solicitud post en http
      final response = await http.post(
        Uri.parse(urlCompleta),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": name
        })
      );
      // validar la obtención de datos de la API
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Usuario creado exitosamente: $response');
        return true;
      } else {
        print('Error al crear el usuario: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al crear un usuario: $e');
      throw Exception('Error al crear un usuario: $e');
    }
  }
  
}