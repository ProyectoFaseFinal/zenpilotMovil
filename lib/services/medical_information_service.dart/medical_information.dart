import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MedicalInformationService {
  // obtenemos el endpoint de las variables de entornos
  final baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  //--------------------------------
  //Metodo get para obtener la información médica del usuario
  //--------------------------------
  Future<List<dynamic>> getMedicalInformation() async {
    //construimos el EndPoint completo
    final String urlCompleta= '$baseUrl/api/medical_information';
    try {
      final result = await http.get(Uri.parse(urlCompleta));
      if (result.statusCode == 200) {
        final deCodeMedicalInformation = jsonDecode(result.body);
        print('Datos obtenidos de la API: $deCodeMedicalInformation');
        return deCodeMedicalInformation['data'];
      } else {
        print('Error al obtener los datos de la información médica del usuario: ${result.statusCode} - ${result.body}');
        throw Exception('Error al obtener los datos de la información médica del usuario: ${result.statusCode}');
      }
    } catch (e) {
      print('Error al tratar de obtener los datos de la información médica del usuario');
      throw Exception('Error al tratar de obtener los datos de la información médica del usuario, error: $e');
    }
  }
  
  //--------------------------------
  //Metodo post para obtener la información médica del usuario
  //--------------------------------
  Future<bool> postMedicalInformation(int idUser, String doctor_nombre, String medicina, double altura, String peso) async {
    final urlCompleta = '$baseUrl/api/medical_information';
    try {
      final result = await http.post(
        Uri.parse(urlCompleta),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "idUser": idUser,
          "doctor_nombre": doctor_nombre,
          "medicina": medicina,
          "altura": altura,
          "peso": peso
        })
      );
      if (result.statusCode == 200 || result.statusCode == 201) {
        print('Datos creado con exito');
        return true;
      } else {
        print('Error al crear los datos de la información médica del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error al tratar de obtener la informaci{on medica del usuario}');
      throw Exception('Error al tratar de obtener la información médica del usuario, error: $e');
    }
  }
  //--------------------------------
  //Metodo put para obtener la información médica del usuario
  //--------------------------------
  Future<bool> putMedicalInformation(int id, int idUser, String doctor_nombre, String medicina, double altura, String peso) async {
    final String urlCompleta = '$baseUrl/api/medical_information/$id';
    try {
      final result = await http.put(
        Uri.parse(urlCompleta),
        headers: {
          "Content-Type": 'application/json'
        },
        body: jsonEncode({
          "id": id,
          "idUser": idUser,
          "doctor_nombre": doctor_nombre,
          "medicina": medicina,
          "altura": altura,
          "peso": peso
        })
      );
      if (result.statusCode == 200) {
        print('Datos actualizados con exito');
        return true;
      } else {
        print('Error al actualizar los datos de la información médica del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error al tratar de actualizar la información médica del usuario');
      throw Exception('Error al tratar de actualizar la información médica del usuario, error: $e');
    }
  }

  //--------------------------------
  //Metodo delete para obtener la información médica del usuario
  //--------------------------------
  Future<bool> deleteMedicalInformation(int id) async {
    final String urlCompleta = '$baseUrl/api/medical_information/$id';
    try {
      final result = await http.delete(Uri.parse(urlCompleta));
      if (result.statusCode == 200) {
        print('Datos eliminados con exito');
        return true;
      } else {
        print('Error al eliminar los datos de la información médica del usuario: ${result.statusCode} - ${result.body}');
        return false;
      }
    } catch (e) {
      print('Error al tratar de eliminar la información médica del usuario');
      throw Exception('Error al tratar de eliminar la información médica del usuario, error: $e');
    }
  }
}