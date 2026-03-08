import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final Color lineColor;
  final double maxDistance;

  const ParticleBackground({
    super.key,
    this.particleCount = 50,
    this.particleColor = const Color(0xFF0D47A1),
    this.lineColor = const Color(0xFF00B0FF),
    this.maxDistance = 120,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(() {
        setState(() {
          _updateParticles();
        });
      });
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_particles.isEmpty) {
      _initParticles();
    }
  }

  void _initParticles() {
    final size = MediaQuery.of(context).size;
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        vx: (_random.nextDouble() - 0.5) * 0.5,
        vy: (_random.nextDouble() - 0.5) * 0.5,
        radius: _random.nextDouble() * 2 + 1,
      ));
    }
  }

  void _updateParticles() {
    final size = MediaQuery.of(context).size;
    for (var particle in _particles) {
      particle.x += particle.vx;
      particle.y += particle.vy;

      if (particle.x < 0 || particle.x > size.width) particle.vx *= -1;
      if (particle.y < 0 || particle.y > size.height) particle.vy *= -1;

      particle.x = particle.x.clamp(0, size.width);
      particle.y = particle.y.clamp(0, size.height);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE3F2FD),
            const Color(0xFFFAFAFA),
            const Color(0xFFE1F5FE),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: ParticlePainter(
          particles: _particles,
          particleColor: widget.particleColor,
          lineColor: widget.lineColor,
          maxDistance: widget.maxDistance,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double radius;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color particleColor;
  final Color lineColor;
  final double maxDistance;

  ParticlePainter({
    required this.particles,
    required this.particleColor,
    required this.lineColor,
    required this.maxDistance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final particlePaint = Paint()
      ..color = particleColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = lineColor.withOpacity(0.15)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Dibujar líneas entre partículas cercanas
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distance = sqrt(dx * dx + dy * dy);

        if (distance < maxDistance) {
          final opacity = (1 - distance / maxDistance) * 0.3;
          linePaint.color = lineColor.withOpacity(opacity);
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }

    // Dibujar partículas
    for (var particle in particles) {
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.radius,
        particlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}