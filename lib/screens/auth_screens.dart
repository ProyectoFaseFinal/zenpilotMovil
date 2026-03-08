import 'package:flutter/material.dart';
import 'package:zenpilot_app/styles/app_styles.dart';
import 'package:zenpilot_app/widgets/shared_widgets.dart';
import 'package:zenpilot_app/widgets/particle_background.dart';
import 'package:zenpilot_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authService.getErrorMessage(e)),
            backgroundColor: kErrorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authService.getErrorMessage(e)),
            backgroundColor: kErrorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const AppLogoHeader(
                  title: 'Iniciar Sesión',
                  subtitle: 'Bienvenido de nuevo',
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _emailController,
                  decoration: getInputDecoration(
                    label: 'Email',
                    hint: 'correo@ejemplo.com',
                    icon: Icons.email_outlined,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu email';
                    }
                    if (!value.contains('@')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: getInputDecoration(
                    label: 'Contraseña',
                    hint: '••••••••',
                    icon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: kTextSecondary,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/forgot_password'),
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: kSmallBodyStyle.copyWith(color: kPrimaryColor),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedButton(
                  text: _isLoading ? 'Cargando...' : 'Iniciar Sesión',
                  onPressed: _isLoading ? () {} : _signInWithEmail,
                  icon: Icons.login_outlined,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider(color: kDividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O continúa con',
                        style: kSmallBodyStyle.copyWith(color: kTextSecondary),
                      ),
                    ),
                    const Expanded(child: Divider(color: kDividerColor)),
                  ],
                ),
                const SizedBox(height: 24),
                _GoogleButton(
                  onPressed: _isLoading ? () {} : _signInWithGoogle,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta? ',
                      style: kBodyStyle.copyWith(color: kTextSecondary),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      child: Text(
                        'Regístrate',
                        style: kBodyBoldStyle.copyWith(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppLogoHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AppLogoHeader({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: kH1Style),
        const SizedBox(height: 8),
        Text(subtitle, style: kBodyStyle.copyWith(color: kTextSecondary)),
      ],
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authService.getErrorMessage(e)),
            backgroundColor: kErrorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authService.getErrorMessage(e)),
            backgroundColor: kErrorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppLogoHeader(
                  title: 'Crear Cuenta',
                  subtitle: 'Únete a Zenpilot',
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameController,
                  decoration: getInputDecoration(
                    label: 'Nombre completo',
                    hint: 'Juan Pérez',
                    icon: Icons.person_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: getInputDecoration(
                    label: 'Email',
                    hint: 'correo@ejemplo.com',
                    icon: Icons.email_outlined,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu email';
                    }
                    if (!value.contains('@')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: getInputDecoration(
                    label: 'Contraseña',
                    hint: 'Mínimo 6 caracteres',
                    icon: Icons.lock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: kTextSecondary,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una contraseña';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AnimatedButton(
                  text: _isLoading ? 'Cargando...' : 'Crear Cuenta',
                  onPressed: _isLoading ? () {} : _signUpWithEmail,
                  icon: Icons.person_add_outlined,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider(color: kDividerColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O continúa con',
                        style: kSmallBodyStyle.copyWith(color: kTextSecondary),
                      ),
                    ),
                    const Expanded(child: Divider(color: kDividerColor)),
                  ],
                ),
                const SizedBox(height: 24),
                _GoogleButton(
                  onPressed: _isLoading ? () {} : _signInWithGoogle,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta? ',
                      style: kBodyStyle.copyWith(color: kTextSecondary),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Inicia sesión',
                        style: kBodyBoldStyle.copyWith(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// BIENVENIDA CON EFECTO DE PARTÍCULAS
class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const ParticleBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 0.8, end: 1.0),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                kNeonBlue.withOpacity(0.4),
                                kNeonBlue.withOpacity(0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/zenpilot.png',
                              width: 350,
                              height: 350,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [kPrimaryColor, kAccentColor],
                    ).createShader(bounds),
                    child: Text(
                      'Zenpilot',
                      style: kH1Style.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tu copiloto inteligente para la carretera',
                    style: kBodyStyle.copyWith(
                      color: kTextSecondary,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                  AnimatedButton(
                    text: 'Iniciar sesión',
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                  ),
                  const SizedBox(height: 16),
                  AnimatedButton(
                    text: 'Crear cuenta',
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    isPrimary: false,
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authService.resetPassword(_emailController.text.trim());
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/reset_success');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_authService.getErrorMessage(e)),
            backgroundColor: kErrorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppLogoHeader(
                  title: 'Recuperar Contraseña',
                  subtitle: 'Ingresa tu email para recibir instrucciones',
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: getInputDecoration(
                    label: 'Email',
                    hint: 'correo@ejemplo.com',
                    icon: Icons.email_outlined,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu email';
                    }
                    if (!value.contains('@')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AnimatedButton(
                  text: _isLoading ? 'Enviando...' : 'Enviar Instrucciones',
                  onPressed: _isLoading ? () {} : _sendResetEmail,
                  icon: Icons.send_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                size: 80,
                color: kPrimaryColor,
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Correo Enviado!',
                style: kH1Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Revisa tu bandeja de entrada y sigue las instrucciones para restablecer tu contraseña.',
                style: kBodyStyle.copyWith(color: kTextSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              AnimatedButton(
                text: 'Volver a Iniciar Sesión',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                ),
                icon: Icons.login_outlined,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BOTÓN DE GOOGLE PERSONALIZADO
class _GoogleButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _GoogleButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<_GoogleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kDividerColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(16),
              splashColor: kPrimaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(kPrimaryColor),
                        ),
                      )
                    else
                      Image.asset(
                        'assets/images/google_logo.png',
                        width: 20,
                        height: 20,
                      ),

                    const SizedBox(width: 12),
                    Text(
                      widget.isLoading
                          ? 'CARGANDO...'
                          : 'CONTINUAR CON GOOGLE',
                      style: kButtonTextStyle.copyWith(
                        color: kTextPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ICONO DE GOOGLE DIBUJADO
// ignore: unused_element
class _GoogleIcon extends StatelessWidget {
  final double size;

  // ignore: unused_element_parameter
  const _GoogleIcon({this.size = 24});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _GoogleIconPainter(),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final blueColor = const Color(0xFF4285F4);
    final redColor = const Color(0xFFEA4335);
    final yellowColor = const Color(0xFBBC05);
    final greenColor = const Color(0xFF34A853);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    paint.color = blueColor;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -1.57, 1.57, true, paint);

    paint.color = redColor;
    canvas.drawArc(rect, -1.57, -1.57, true, paint);

    paint.color = yellowColor;
    canvas.drawArc(rect, 1.57, 1.0, true, paint);

    paint.color = greenColor;
    canvas.drawArc(rect, 2.57, 1.0, true, paint);

    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.5, paint);

    paint.color = blueColor;
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - radius * 0.15,
        radius * 0.8,
        radius * 0.3,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
