import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/fatigue_chart.dart';
import '../services/smartwatch_service/smartwatch_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';


// ---------------- HOME CONTENT ----------------
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  static const List<double> fatigueData = [25, 45, 60, 40, 55, 35, 30];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: kPrimaryColor,
          expandedHeight: 120,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Zenpilot', style: kH2Style.copyWith(color: Colors.white)),
            centerTitle: true,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              NeonCard(
                hasNeonEffect: true,
                neonColor: kPrimaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¡Bienvenido!', style: kH2Style),
                    Text('Tu jornada está en curso', style: kSmallBodyStyle),
                    const SizedBox(height: 20),
                    AnimatedButton(
                      text: 'Terminar jornada',
                      onPressed: () => Navigator.pushNamed(context, '/end_session'),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}


// ---------------- DEVICES CONTENT ----------------
class DevicesContent extends StatefulWidget {
  const DevicesContent({super.key});

  @override
  State<DevicesContent> createState() => _DevicesContentState();
}

class _DevicesContentState extends State<DevicesContent> {

  final SmartwatchService _smartwatchService = SmartwatchService();

  List<Map<String, dynamic>> smartwatches = [];
  bool loading = true;

  Timer? _timer;
  final Random random = Random();

  Map<int, List<double>> heartHistory = {};
  Map<int, List<double>> speedHistory = {};

  @override
  void initState() {
    super.initState();
    _loadSmartwatches();

    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _simulateMetrics();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadSmartwatches() async {

    final prefs = await SharedPreferences.getInstance();
    final idUser = prefs.getInt('userId');

    final data = await _smartwatchService.getSmartwatch();

    final userDevices = data.where((device) {
      final deviceUserId = int.parse(device['iduser'].toString());
      return deviceUserId == idUser;
    }).map<Map<String,dynamic>>((device) => {
      "id": device["id"],
      "name": device["name"],
      "frecuencia_cardiaca": device["frecuencia_cardiaca"],
      "velocidad_promedio": device["velocidad_promedio"],
      "iduser": device["iduser"]
    }).toList();

    for (var d in userDevices) {
      heartHistory[d["id"]] = [d["frecuencia_cardiaca"].toDouble()];
      speedHistory[d["id"]] = [d["velocidad_promedio"].toDouble()];
    }

    setState(() {
      smartwatches = userDevices;
      loading = false;
    });
  }


  void _simulateMetrics() {

    if (smartwatches.isEmpty) return;

    setState(() {

      for (var device in smartwatches) {

        int frecuencia = device["frecuencia_cardiaca"];
        int velocidad = device["velocidad_promedio"];

        frecuencia += random.nextInt(11) - 5;
        velocidad += random.nextInt(9) - 4;

        frecuencia = frecuencia.clamp(50,120);
        velocidad = velocidad.clamp(80,200);

        device["frecuencia_cardiaca"] = frecuencia;
        device["velocidad_promedio"] = velocidad;

        heartHistory[device["id"]]!.add(frecuencia.toDouble());
        speedHistory[device["id"]]!.add(velocidad.toDouble());

        if (heartHistory[device["id"]]!.length > 20) {
          heartHistory[device["id"]]!.removeAt(0);
        }

        if (speedHistory[device["id"]]!.length > 20) {
          speedHistory[device["id"]]!.removeAt(0);
        }

      // Solo actualizando métricas
      _smartwatchService.putSmartwatch(
        id: device["id"],
        frecuenciaCardiaca: frecuencia,
        velocidadPromedio: velocidad,
        name: device["name"],
      );

      }

    });

  }

  Future<void> _editDevice(Map<String, dynamic> device) async {
    final controller = TextEditingController(text: device["name"]);

    final result = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Smartwatch"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Nombre del dispositivo",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // cancelar
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;

              // Llamamos al servicio enviando solo el nombre
              final success = await _smartwatchService.putSmartwatch(
              id: device["id"],
              name: newName,
              // frecuenciaCardiaca y velocidadPromedio se mantienen iguales
              frecuenciaCardiaca: device["frecuencia_cardiaca"],
              velocidadPromedio: device["velocidad_promedio"],
            );

              if (success) {
                setState(() {
                  device["name"] = newName;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Smartwatch actualizado"),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context); // cerramos el dialog
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDevice(int id) async {

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar dispositivo"),
        content: const Text("¿Seguro que deseas eliminar este smartwatch?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context,false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context,true),
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );

    if(confirm != true) return;

    final result = await _smartwatchService.deleteSmartwatch(id);

    if(result){

      setState(() {
        smartwatches.removeWhere((d) => d["id"] == id);
        heartHistory.remove(id);
        speedHistory.remove(id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Smartwatch eliminado"),
          backgroundColor: Color.fromARGB(255, 23, 172, 0),
        ),
      );

    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kBackgroundColor,

      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Mis Dispositivos', style: kH2Style.copyWith(color: Colors.white)),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_device');
          _loadSmartwatches();
        },
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text('Dispositivos Vinculados', style: kH3Style),

            const SizedBox(height: 16),

            if (loading)
              const Center(child: CircularProgressIndicator())

            else if (smartwatches.isEmpty)
              const Text("No tienes dispositivos registrados")

            else
              Column(
                children: smartwatches.map((device) {

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildDeviceCard(device),
                  );

                }).toList(),
              ),

          ],
        ),
      ),
    );
  }


  Widget _buildDeviceCard(Map<String,dynamic> device) {

    final name = device['name'];
    final frecuencia = device['frecuencia_cardiaca'];
    final velocidad = device['velocidad_promedio'];

    final heartData = heartHistory[device["id"]]!;
    final speedData = speedHistory[device["id"]]!;

    return NeonCard(

      onTap: () {
        Navigator.pushNamed(
          context,
          '/device_detail',
          arguments: device,
        );
      },

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  const Icon(Icons.watch, color: kSuccessColor),
                  const SizedBox(width: 10),
                  Text(name, style: kBodyBoldStyle),
                ],
              ),
              

              Row(
                children: [

                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editDevice(device);
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteDevice(device["id"]);
                    },
                  ),

                ],
              )

            ],
          ),

          const SizedBox(height: 10),

          Text("Frecuencia: $frecuencia BPM", style: kSmallBodyStyle),

          SizedBox(
            height: 50,
            child: MiniChart(
              data: heartData,
              color: Colors.red,
            ),
          ),

          const SizedBox(height: 8),

          Text("Velocidad: $velocidad km/h", style: kSmallBodyStyle),

          SizedBox(
            height: 50,
            child: MiniChart(
              data: speedData,
              color: Colors.blue,
            ),
          ),

        ],
      ),
    );
  }

}


// ---------------- MINI CHART ----------------
class MiniChart extends StatelessWidget {

  final List<double> data;
  final Color color;

  const MiniChart({
    super.key,
    required this.data,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChartPainter(data, color),
      size: Size.infinite,
    );
  }

}

class ChartPainter extends CustomPainter {

  final List<double> data;
  final Color color;

  ChartPainter(this.data,this.color);

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    double dx = size.width / (data.length - 1);

    double minVal = data.reduce(min);
    double maxVal = data.reduce(max);

    for (int i = 0; i < data.length; i++) {

      double normalized = (data[i] - minVal) / (maxVal - minVal + 1);

      double x = i * dx;
      double y = size.height - (normalized * size.height);

      if (i == 0) {
        path.moveTo(x,y);
      } else {
        path.lineTo(x,y);
      }

    }

    canvas.drawPath(path, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}


// ---------------- PROFILE ----------------
class ProfileContentPlaceholder extends StatelessWidget {
  const ProfileContentPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Placeholder', style: kBodyStyle),
    );
  }
}


// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeContent(),
    DevicesContent(),
    ProfileContentPlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {

          if (index == 2) {
            Navigator.pushNamed(context, '/profile_menu');
          } else {
            setState(() => _currentIndex = index);
          }

        },
      ),
    );
  }
}