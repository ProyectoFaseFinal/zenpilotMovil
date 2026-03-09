import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zenpilot_app/styles/app_styles.dart';
import 'package:zenpilot_app/screens/auth_screens.dart';
import 'package:zenpilot_app/screens/main_tabs.dart';
import 'package:zenpilot_app/screens/device_screens.dart';
import 'package:zenpilot_app/screens/secondary_screens.dart';
import 'package:zenpilot_app/services/auth_service.dart';
import 'package:zenpilot_app/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configuración de la barra de estado y navegación
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: kBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // correr el archivo .env
    await dotenv.load(fileName: ".env");
    runApp(const ZenpilotApp());
  } catch (e, stackTrace) {
    print('Error durante la inicialización: $e');
    print(stackTrace);
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error al iniciar la app:\n$e',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ZenpilotApp extends StatelessWidget {
  const ZenpilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenpilot',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password': (context) => const ForgotPasswordScreen(),
        '/verification': (context) => const VerificationScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/reset_success': (context) => const ResetSuccessScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_device': (context) => const AddDeviceScreen(),
        '/device_detail': (context) => const DeviceDetailScreen(),
        '/end_session': (context) => const EndSessionScreen(),
        '/profile_menu': (context) => const ProfileMenuScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/help_support': (context) => const HelpSupportScreen(),
        '/copilot': (context) => const CopilotScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/offline_mode': (context) => const OfflineModeScreen(),
      },
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor,
        primary: kPrimaryColor,
        secondary: kAccentColor,
        surface: kSurfaceColor,
        error: kErrorColor,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: kBackgroundColor,
      cardColor: kCardColor,
      dividerColor: kDividerColor,

      appBarTheme: const AppBarTheme(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      cardTheme: CardThemeData(
        color: kCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kDividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kErrorColor, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: kBodyStyle.copyWith(color: kTextSecondary),
        hintStyle: kSmallBodyStyle,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: kButtonTextStyle,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: kBodyStyle.copyWith(fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimaryColor,
          side: const BorderSide(color: kPrimaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: kButtonTextStyle,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: kCardColor,
        contentTextStyle: kBodyStyle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: kCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: kH2Style,
        contentTextStyle: kBodyStyle,
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: kSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: kPrimaryColor,
        linearTrackColor: kDividerColor,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return kPrimaryColor;
          return kTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return kPrimaryColor.withOpacity(0.5);
          return kDividerColor;
        }),
      ),

      dividerTheme: const DividerThemeData(
        color: kDividerColor,
        thickness: 1,
        space: 20,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      textTheme: const TextTheme(
        displayLarge: kH1Style,
        displayMedium: kH2Style,
        displaySmall: kH3Style,
        bodyLarge: kBodyStyle,
        bodyMedium: kBodyStyle,
        bodySmall: kSmallBodyStyle,
        labelLarge: kButtonTextStyle,
        labelSmall: kCaptionStyle,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

// Widget que decide qué pantalla mostrar según el estado de autenticación
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Mostrar loading mientras se verifica el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: kBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
          );
        }

        // Si hay usuario autenticado, ir a Home
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Si no hay usuario, mostrar Login
        return const BienvenidaScreen();
      },
    );
  }
}
