import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../widgets/shared_widgets.dart';

// --- AGREGAR DISPOSITIVO ---
class AddDeviceScreen extends StatelessWidget {
  const AddDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Agregar Dispositivo', style: kH2Style.copyWith(color: Colors.white)),
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
            Text('Selecciona el tipo de dispositivo', style: kH3Style),
            const SizedBox(height: 20),
            _buildDeviceOption(
              context,
              Icons.watch_outlined,
              'Smartwatch / Banda',
              'Monitoreo de ritmo cardiaco y fatiga',
              kPrimaryColor,
            ),
            const SizedBox(height: 12),
            _buildDeviceOption(
              context,
              Icons.sensors_outlined,
              'Cubierta de Volante',
              'Estabilidad y control de agarre',
              kWarningColor,
            ),
            const SizedBox(height: 12),
            _buildDeviceOption(
              context,
              Icons.settings_input_hdmi_outlined,
              'Sensor Genérico',
              'Dispositivos IoT compatibles',
              kTextSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceOption(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return NeonCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Iniciando emparejamiento con $title...'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: kBodyBoldStyle),
                const SizedBox(height: 4),
                Text(subtitle, style: kSmallBodyStyle),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: kTextSecondary),
        ],
      ),
    );
  }
}

// --- DETALLE DE DISPOSITIVO ---
class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final deviceName = args?['name'] ?? 'Dispositivo';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(deviceName, style: kH2Style.copyWith(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeonCard(
              hasNeonEffect: true,
              neonColor: kSuccessColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusItem('Conexión', 'Conectado', kSuccessColor, Icons.check_circle_outline),
                  Container(width: 1, height: 40, color: kDividerColor),
                  _buildStatusItem('Batería', '80%', kPrimaryColor, Icons.battery_charging_full_outlined),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Métricas Recientes', style: kH3Style),
            const SizedBox(height: 16),
            _buildMetricTile(Icons.speed_outlined, 'Velocidad Promedio', '70 km/h', kPrimaryColor),
            _buildMetricTile(Icons.favorite_outline, 'Ritmo Cardiaco', '75 BPM', kErrorColor),
            _buildMetricTile(Icons.access_time_outlined, 'Tiempo de Uso', '4h 15min', kTextSecondary),
            const SizedBox(height: 32),
            AnimatedButton(
              text: 'Desvincular dispositivo',
              onPressed: () {},
              isPrimary: false,
              icon: Icons.link_off_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(label, style: kSmallBodyStyle),
        const SizedBox(height: 4),
        Text(value, style: kBodyBoldStyle.copyWith(color: color)),
      ],
    );
  }

  Widget _buildMetricTile(IconData icon, String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeonCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: kBodyStyle),
            ),
            Text(value, style: kBodyBoldStyle.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class NeonCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool hasNeonEffect;
  final Color neonColor;

  const NeonCard({
    required this.child,
    this.onTap,
    this.hasNeonEffect = false,
    this.neonColor = kPrimaryColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: neonColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}