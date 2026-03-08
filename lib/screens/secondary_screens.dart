// ---------------------------------------------------------------------------
// FULL FILE COMPLETO — TODAS LAS PANTALLAS + COPILOTO ACTUALIZADO A GEMINI
// ---------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:avatar_glow/avatar_glow.dart';

// Archivos existentes de tu app
import '../styles/app_styles.dart';
import '../widgets/shared_widgets.dart';
import '../services/gemini_service.dart';

// ---------------------------------------------------------------------------
// TERMINAR JORNADA
// ---------------------------------------------------------------------------

class EndSessionScreen extends StatelessWidget {
  const EndSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: kTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kWarningColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.timer_off_outlined,
                  size: 80,
                  color: kWarningColor,
                ),
              ),
              const SizedBox(height: 32),
              Text('¿Terminar jornada?', style: kH1Style),
              const SizedBox(height: 12),
              Text(
                'Se detendrá el monitoreo de todos tus dispositivos',
                textAlign: TextAlign.center,
                style: kBodyStyle.copyWith(color: kTextSecondary),
              ),
              const SizedBox(height: 48),
              AnimatedButton(
                text: 'Confirmar',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              AnimatedButton(
                text: 'Cancelar',
                onPressed: () => Navigator.pop(context),
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PERFIL
// ---------------------------------------------------------------------------

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Mi Perfil', style: kH2Style.copyWith(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.1)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/32.jpg',
                      ),
                      backgroundColor: Colors.white,
                      child: SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Wilson Trevor',
                    style: kH2Style.copyWith(color: Colors.white),
                  ),
                  Text(
                    'trevor@gmail.com',
                    style: kSmallBodyStyle.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildMenuItem(
              context,
              Icons.settings_outlined,
              'Configuración',
              '/settings',
            ),
            _buildMenuItem(
              context,
              Icons.smart_toy_outlined,
              'Mi Copiloto IA',
              '/copilot',
            ),
            _buildMenuItem(
              context,
              Icons.headset_mic_outlined,
              'Ayuda y Soporte',
              '/help_support',
            ),
            _buildMenuItem(
              context,
              Icons.shield_outlined,
              'Política de Privacidad',
              '',
            ),
            _buildMenuItem(context, Icons.info_outline, 'Acerca de', ''),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedButton(
                text: 'Cerrar sesión',
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (r) => false,
                  );
                },
                isPrimary: false,
                icon: Icons.logout_outlined,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: kPrimaryColor, size: 24),
      ),
      title: Text(title, style: kBodyStyle),
      trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
      onTap: () {
        if (route.isNotEmpty) {
          Navigator.pushNamed(context, route);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Navegando a $title...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
    );
  }
}

// ---------------------------------------------------------------------------
// CONFIGURACIÓN
// ---------------------------------------------------------------------------

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Configuración',
          style: kH2Style.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSection('General'),
          _buildSettingTile(
            context,
            Icons.cloud_off_outlined,
            'Modo Sin Conexión',
            '/offline_mode',
          ),
          _buildSettingTile(
            context,
            Icons.notifications_outlined,
            'Notificaciones',
            '/notifications',
          ),
          _buildSettingTile(context, Icons.security_outlined, 'Seguridad', ''),
          _buildSection('Preferencias'),
          ListTile(
            leading: Icon(Icons.language_outlined, color: kPrimaryColor),
            title: Text('Idioma', style: kBodyStyle),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Español', style: kSmallBodyStyle),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: kTextSecondary),
              ],
            ),
            onTap: () => _showLanguageDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Text(title, style: kH3Style.copyWith(color: kPrimaryColor)),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: kPrimaryColor),
      title: Text(title, style: kBodyStyle),
      trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
      onTap: () {
        if (route.isNotEmpty) Navigator.pushNamed(context, route);
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Seleccionar idioma', style: kH3Style),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(context, 'Español', true),
              const Divider(),
              _buildLanguageOption(context, 'English', false),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String lang,
    bool selected,
  ) {
    return ListTile(
      title: Text(lang, style: kBodyStyle),
      trailing: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: selected ? kPrimaryColor : kTextSecondary,
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}

// ---------------------------------------------------------------------------
// AYUDA Y SOPORTE
// ---------------------------------------------------------------------------

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Ayuda y Soporte',
          style: kH2Style.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preguntas Frecuentes', style: kH3Style),
            const SizedBox(height: 16),
            _faq(
              '¿Cómo vinculo un dispositivo?',
              'Ve a Dispositivos > Agregar dispositivo.',
            ),
            _faq(
              '¿Qué hago si pierdo conexión?',
              'Activa el Modo Sin Conexión.',
            ),
            _faq('¿Cómo termino mi jornada?', 'Presiona "Terminar jornada".'),
            const SizedBox(height: 24),
            Text('Contáctanos', style: kH3Style),
            _contact(Icons.email_outlined, 'Email', 'soporte@zenpilot.com'),
            _contact(Icons.phone_outlined, 'Teléfono', '+1 555 123 4567'),
          ],
        ),
      ),
    );
  }

  Widget _faq(String q, String a) {
    return NeonCard(
      child: ExpansionTile(
        title: Text(q, style: kBodyBoldStyle),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(a, style: kSmallBodyStyle),
          ),
        ],
      ),
    );
  }

  Widget _contact(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: NeonCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: kPrimaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kBodyBoldStyle),
                Text(value, style: kSmallBodyStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// COPILOTO IA COMPLETO — ACTUALIZADO A GEMINI SERVICE
// ---------------------------------------------------------------------------

class CopilotScreen extends StatefulWidget {
  const CopilotScreen({super.key});

  @override
  State<CopilotScreen> createState() => _CopilotScreenState();
}

class _CopilotScreenState extends State<CopilotScreen>
    with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  final GeminiService _gemini = GeminiService();

  bool _isListening = false;
  bool _isProcessing = false;

  String _userText = '';
  List<Map<String, String>> _conversation = [];

  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _setupTts();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage("es-ES");
    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<void> _requestMic() async {
    final status = await Permission.microphone.status;

    if (status.isGranted) {
      return; // Ya tiene permiso
    }

    if (status.isDenied) {
      // Primera vez o denegado temporalmente
      final result = await Permission.microphone.request();

      if (result.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✓ Micrófono activado. ¡Puedes hablar ahora!"),
              backgroundColor: kSuccessColor,
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }
    }

    if (status.isPermanentlyDenied || status.isDenied) {
      // Mostrar diálogo para ir a configuración
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.mic_off, color: kErrorColor),
            const SizedBox(width: 12),
            Expanded(child: Text('Permiso de Micrófono', style: kH3Style)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Para usar el Asistente IA, necesitas activar el permiso del micrófono.',
              style: kBodyStyle,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pasos:',
                    style: kBodyBoldStyle.copyWith(color: kPrimaryColor),
                  ),
                  const SizedBox(height: 8),
                  _buildStep('1', 'Toca "Ir a Configuración"'),
                  _buildStep('2', 'Busca "Permisos"'),
                  _buildStep('3', 'Activa "Micrófono"'),
                  _buildStep('4', 'Regresa a la app'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(ctx);
              await openAppSettings();
            },
            icon: const Icon(Icons.settings),
            label: const Text('Ir a Configuración'),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: kSmallBodyStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: kSmallBodyStyle)),
        ],
      ),
    );
  }

  Future<void> _startListening() async {
    await _requestMic();

    final available = await _speech.initialize(
      onStatus: (s) {},
      onError: (e) {},
    );

    if (!available) return;

    setState(() {
      _isListening = true;
      _userText = "";
    });

    _speech.listen(
      localeId: "es_ES",
      onResult: (r) => setState(() => _userText = r.recognizedWords),
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);

    if (_userText.isNotEmpty) _process(_userText);
  }

  Future<void> _process(String message) async {
    setState(() {
      _isProcessing = true;
      _conversation.add({"role": "user", "content": message});
    });

    final reply = await _gemini.sendMessage(message);

    setState(() {
      _conversation.add({"role": "assistant", "content": reply});
      _isProcessing = false;
    });

    await _tts.speak(reply);
  }

  void _sendQuick(String msg) {
    _tts.stop();
    _process(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Mi Copiloto",
          style: kH2Style.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _tts.stop();
            Navigator.pop(context);
          },
        ),
        actions: [
          if (_conversation.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white),
              onPressed: () {
                setState(() => _conversation.clear());
                _tts.stop();
              },
            ),
        ],
      ),

      // -------------------------------------------------------------------
      body: Column(
        children: [
          Expanded(
            child: _conversation.isEmpty ? _emptyState() : _conversationList(),
          ),

          if (!_isListening && !_isProcessing && _conversation.isEmpty)
            _quickMessages(),

          _statusBar(),
          _micButton(),
        ],
      ),
    );
  }

  // --- UI VACÍO ---
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              glowColor: kPrimaryColor,
              animate: true,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor.withOpacity(0.1),
                ),
                child: const Icon(Icons.mic, color: kPrimaryColor, size: 80),
              ),
            ),
            const SizedBox(height: 20),
            Text("Asistente IA", style: kH2Style),
            Text(
              "Toca el micrófono para hablar conmigo.",
              style: kBodyStyle.copyWith(color: kTextSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- LISTA DE MENSAJES ---
  Widget _conversationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _conversation.length,
      itemBuilder: (_, i) {
        final msg = _conversation[i];
        final user = msg["role"] == "user";

        return Row(
          mainAxisAlignment: user
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!user)
              CircleAvatar(
                backgroundColor: kPrimaryColor.withOpacity(.1),
                child: const Icon(Icons.smart_toy, color: kPrimaryColor),
              ),
            if (!user) const SizedBox(width: 8),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: user ? kPrimaryColor : kSurfaceColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  msg["content"]!,
                  style: kBodyStyle.copyWith(
                    color: user ? Colors.white : kTextPrimary,
                  ),
                ),
              ),
            ),
            if (user) const SizedBox(width: 8),
            if (user)
              const CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Icon(Icons.person, color: Colors.white),
              ),
          ],
        );
      },
    );
  }

  // --- MENSAJES RÁPIDOS ---
  Widget _quickMessages() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: GeminiService.quickMessages.length,
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(GeminiService.quickMessages[i]),
              onPressed: () => _sendQuick(GeminiService.quickMessages[i]),
            ),
          );
        },
      ),
    );
  }

  Widget _statusBar() {
    if (!_isListening && !_isProcessing) return const SizedBox();

    String txt = _isListening ? "Escuchando..." : "Pensando...";
    Color col = _isListening ? kPrimaryColor : kWarningColor;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: kSurfaceColor,
      child: Row(
        children: [
          Icon(_isListening ? Icons.mic : Icons.sync, color: col),
          const SizedBox(width: 10),
          Text(txt, style: kBodyStyle.copyWith(color: col)),
        ],
      ),
    );
  }

  // --- BOTÓN DE MICRÓFONO ---
  Widget _micButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: kSurfaceColor),
      child: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: _isListening ? _stopListening : _startListening,
            child: AvatarGlow(
              animate: _isListening,
              glowColor: kPrimaryColor,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _isListening ? kErrorColor : kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NOTIFICACIONES
// ---------------------------------------------------------------------------

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Notificaciones',
          style: kH2Style.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Recientes', style: kH3Style),
          const SizedBox(height: 16),
          _noti(
            Icons.warning_amber_outlined,
            "Alerta de Fatiga",
            "Nivel alto detectado",
            kErrorColor,
          ),
          _noti(
            Icons.battery_alert_outlined,
            "Batería Baja",
            "Smartwatch al 15%",
            kWarningColor,
          ),
          _noti(
            Icons.check_circle_outline,
            "Dispositivo Conectado",
            "Cubierta vinculada",
            kSuccessColor,
          ),
        ],
      ),
    );
  }

  Widget _noti(IconData icon, String t, String sub, Color c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t, style: kBodyBoldStyle),
                  Text(sub, style: kSmallBodyStyle),
                ],
              ),
            ),
            Text("Ahora", style: kCaptionStyle),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MODO SIN CONEXIÓN
// ---------------------------------------------------------------------------

class OfflineModeScreen extends StatefulWidget {
  const OfflineModeScreen({super.key});

  @override
  State<OfflineModeScreen> createState() => _OfflineModeScreenState();
}

class _OfflineModeScreenState extends State<OfflineModeScreen> {
  bool _offline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Modo Sin Conexión",
          style: kH2Style.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NeonCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Activar Modo Offline", style: kBodyBoldStyle),
                    Switch(
                      value: _offline,
                      onChanged: (v) => setState(() => _offline = v),
                      activeColor: kPrimaryColor,
                    ),
                  ],
                ),
                Text("Los datos se guardan localmente", style: kSmallBodyStyle),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text("Almacenamiento Local", style: kH3Style),
          const SizedBox(height: 16),
          _data(Icons.storage_outlined, "Datos guardados", "52 MB"),
          const SizedBox(height: 12),
          _data(Icons.sync_outlined, "Última sincronización", "Ayer 10:30 AM"),
          const SizedBox(height: 24),
          AnimatedButton(
            text: "Sincronizar ahora",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Sincronizando..."),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _data(IconData icon, String t, String v) {
    return NeonCard(
      child: Row(
        children: [
          Icon(icon, color: kPrimaryColor),
          const SizedBox(width: 16),
          Expanded(child: Text(t, style: kBodyStyle)),
          Text(v, style: kBodyBoldStyle),
        ],
      ),
    );
  }
}
