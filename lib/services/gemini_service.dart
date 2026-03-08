import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  // --------------------------------------------------
  // API KEY — REEMPLAZA CON TU CLAVE REAL
  // --------------------------------------------------
  static const String _apiKey = "AIzaSyCM3Br0cv_VBmgJS50BaC0sPjMEy9lD62E";

  // --------------------------------------------------
  // ENDPOINT oficial Gemini (texto) - versión v1beta con gemini-2.0-flash
  // --------------------------------------------------
  static const String _apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  // --------------------------------------------------
  // ENVÍO DE MENSAJE A GEMINI
  // --------------------------------------------------
  Future<String> sendMessage(String userMessage) async {
    try {
      final uri = Uri.parse(_apiUrl);

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "${_systemPrompt()}\n\nUsuario: $userMessage"},
            ],
          },
        ],
        "generationConfig": {"temperature": 0.6, "maxOutputTokens": 200},
      });

      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "X-goog-api-key": _apiKey,  // API key en header, no en query param
        },
        body: body,
      );

      if (response.statusCode != 200) {
        print("❌ Error Gemini: ${response.statusCode} - ${response.body}");
        return "Hubo un problema al procesar tu solicitud.";
      }

      final json = jsonDecode(response.body);

      final text = json["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

      if (text == null) {
        print("❌ Respuesta sin texto válido: $json");
        return "No pude generar respuesta.";
      }

      return text.trim();
    } catch (e) {
      print("❌ Error al conectar con Gemini: $e");
      return "No pude conectarme, revisa tu conexión.";
    }
  }

  // --------------------------------------------------
  // PROMPT DEL SISTEMA — TONO DEL COPILOTO
  // --------------------------------------------------
  String _systemPrompt() {
    return """
Eres **Zenpilot drive**, un asistente de voz inteligente y personalizado para conductores profesionales de transporte público, privado y ejecutivo.

Tu función es ser el copiloto del conductor, ayudándole a manejar de manera segura y cuidando su bienestar durante la jornada.

Debes cumplir estas reglas:

- Responde siempre en **español**.
- Usa un lenguaje claro, breve y respetuoso (2 o 3 oraciones máximo).
- Prioriza la **seguridad vial y el bienestar del conductor**.
- Nunca pidas que el conductor mire la pantalla mientras está manejando.
- Detecta signos de fatiga o distracción y recomienda pausas o descansos.
- Informa sobre la próxima parada, tiempo de conducción y cualquier dato relevante del viaje.
- Mantén un tono profesional, cálido y empático.
- Si el conductor reporta algún problema o inconveniente, indica que te comuniques con el administrador para evaluar el asunto y brindar ayuda.

Funciones clave:

- Dar consejos para conducir con seguridad y evitar accidentes.
- Monitorear y evaluar el nivel de fatiga y distracción del conductor.
- Informar el historial de bienestar y alertas recientes.
- Proveer información operativa, como próximas paradas y tiempo manejado.
- Facilitar comunicación con el administrador si surge alguna emergencia o incidencia.

Eres un asistente confiable, atento y siempre listo para apoyar al conductor en todo momento.
""";
  }

  // --------------------------------------------------
  // MENSAJES RÁPIDOS — PARA LOS CHIP BUTTONS
  // --------------------------------------------------
  static const List<String> quickMessages = [
    "¿Cómo estoy de fatiga hoy?",
    "¿Necesito un descanso?",
    "¿Cuánto tiempo llevo manejando?",
    "¿Qué dispositivos tengo conectados?",
    "Explícame una función de Zenpilot.",
  ];
}
