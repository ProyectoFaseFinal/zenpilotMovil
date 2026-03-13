import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../widgets/shared_widgets.dart';
import '../services/smartwatch_service/smartwatch_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- AGREGAR DISPOSITIVO ---
class AddDeviceScreen extends StatelessWidget {
  const AddDeviceScreen({super.key});

  Future<void> _mostrarModalNombreSmartwatch(BuildContext context) async {
    final parentContext = context;
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nombre del Smartwatch'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Ej: Apple Watch, Huawei Watch...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                final name = nameController.text.trim();

                if (name.isNotEmpty) {
                  Navigator.pop(context);
                  _guardarSmartwacht(parentContext, name);
                }
              },
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _guardarSmartwacht(BuildContext context, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('userId') ?? 0;
    print("id usuario prefs: $idUser");

    final int frecuenciaCardiaca = 47;
    final int velocidadPromedio = 110;

    final objeto = {
      'idUser': idUser,
      'frecuencia_cardiaca': frecuenciaCardiaca,
      'velocidad_promedio': velocidadPromedio,
      'name': name
    };

    print(objeto);

    final result = await SmartwatchService().postSmartwatch(
      idUser,
      frecuenciaCardiaca,
      velocidadPromedio,
      name,
    );

    if (result) {
      print('Smartwatch guardado exitosamente');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Smartwatch guardado exitosamente'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      print('Error al guardar el smartwatch');
    }
  }

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
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceOption(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return NeonCard(
      onTap: () {
        _mostrarModalNombreSmartwatch(context);
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
    final frecuencia = args?['frecuencia_cardiaca'] ?? 0;
    final velocidad = args?['velocidad_promedio'] ?? 0;

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
                  _buildStatusItem(
                    'Conexión',
                    'Conectado',
                    kSuccessColor,
                    Icons.check_circle_outline,
                  ),

                  Container(width: 1, height: 40, color: kDividerColor),

                  _buildStatusItem(
                    'Batería',
                    '80%',
                    kPrimaryColor,
                    Icons.battery_charging_full_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text('Métricas Recientes', style: kH3Style),

            const SizedBox(height: 16),

            // 👇 AHORA USA LOS DATOS DEL SMARTWATCH
            _buildMetricTile(
              Icons.speed_outlined,
              'Velocidad Promedio',
              '$velocidad km/h',
              kPrimaryColor,
            ),

            _buildMetricTile(
              Icons.favorite_outline,
              'Ritmo Cardiaco',
              '$frecuencia BPM',
              kErrorColor,
            ),

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