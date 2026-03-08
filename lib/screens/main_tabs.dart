import 'package:flutter/material.dart';
import '../styles/app_styles.dart';
import '../widgets/shared_widgets.dart';
import '../widgets/fatigue_chart.dart';

// --- HOME CONTENT ---
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // Datos de ejemplo para la semana
  static const List<double> fatigueData = [25, 45, 60, 40, 55, 35, 30];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: kPrimaryColor,
          expandedHeight: 120,
          floating: true,
          pinned: false,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Zenpilot', style: kH2Style.copyWith(color: Colors.white)),
            centerTitle: true,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/notifications'),
            ),
          ],
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.wb_sunny_outlined, color: kPrimaryColor, size: 28),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('¡Bienvenido!', style: kH2Style),
                              Text('Tu jornada está en curso', style: kSmallBodyStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AnimatedButton(
                      text: 'Terminar jornada',
                      onPressed: () => Navigator.pushNamed(context, '/end_session'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Monitoreo en Tiempo Real', style: kH3Style),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                children: const [
                  MetricCard(
                    icon: Icons.favorite_outline,
                    title: 'Frecuencia Cardiaca',
                    value: '75 BPM',
                    color: kErrorColor,
                  ),
                  MetricCard(
                    icon: Icons.directions_car_outlined,
                    title: 'Estabilidad',
                    value: '85%',
                    color: kWarningColor,
                  ),
                  MetricCard(
                    icon: Icons.battery_charging_full_outlined,
                    title: 'Batería',
                    value: '90%',
                    color: kSuccessColor,
                  ),
                  MetricCard(
                    icon: Icons.cloud_outlined,
                    title: 'Conexión',
                    value: 'Activa',
                    color: kPrimaryColor,
                    hasNeonEffect: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Historial de Fatiga', style: kH3Style),
              const SizedBox(height: 16),
              NeonCard(
                child: Column(
                  children: [
                    const FatigueChart(
                      data: fatigueData,
                      height: 200,
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => _buildHistoryModal(context),
                        );
                      },
                      icon: const Icon(Icons.history, color: kPrimaryColor, size: 20),
                      label: Text('Ver historial completo', style: kBodyBoldStyle.copyWith(color: kPrimaryColor)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ]),
          ),
        ),
      ],
    );
  }

  static Widget _buildHistoryModal(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: kDividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Historial Completo', style: kH2Style),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 7,
              itemBuilder: (context, index) {
                final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
                final values = fatigueData;
                final color = values[index] > 50 ? kErrorColor : values[index] > 30 ? kWarningColor : kSuccessColor;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: NeonCard(
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${values[index].toInt()}%',
                              style: kBodyBoldStyle.copyWith(color: color),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(days[index], style: kBodyBoldStyle),
                              Text(
                                values[index] > 50 ? 'Fatiga alta' : values[index] > 30 ? 'Fatiga media' : 'Fatiga baja',
                                style: kSmallBodyStyle.copyWith(color: color),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: kTextSecondary),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- DEVICES CONTENT ---
class DevicesContent extends StatelessWidget {
  const DevicesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Mis Dispositivos', style: kH2Style.copyWith(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add_device'),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Agregar', style: kButtonTextStyle.copyWith(color: Colors.white)),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dispositivos Vinculados', style: kH3Style),
            const SizedBox(height: 16),
            _buildDeviceCard(
              context,
              'Smartwatch Monitor',
              'Conectado • 80% batería',
              Icons.watch_outlined,
              kSuccessColor,
            ),
            const SizedBox(height: 12),
            _buildDeviceCard(
              context,
              'Cubierta de Volante',
              'Activo • 95% batería',
              Icons.sensors_outlined,
              kPrimaryColor,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard(BuildContext context, String name, String status, IconData icon, Color color) {
    return NeonCard(
      onTap: () => Navigator.pushNamed(context, '/device_detail', arguments: {'name': name}),
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
                Text(name, style: kBodyBoldStyle),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(status, style: kSmallBodyStyle),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: kTextSecondary),
        ],
      ),
    );
  }
}

// --- PROFILE PLACEHOLDER ---
class ProfileContentPlaceholder extends StatelessWidget {
  const ProfileContentPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Placeholder', style: kBodyStyle),
    );
  }
}

// --- HOME SCREEN ---
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