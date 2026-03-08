import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream para escuchar cambios en el estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Iniciar sesión con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Iniciar el proceso de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return null;
      }

      // Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crear credenciales para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase con las credenciales de Google
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      rethrow;
    }
  }

  // Registrar con email y contraseña
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error al registrar: $e');
      rethrow;
    }
  }

  // Iniciar sesión con email y contraseña
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error al iniciar sesión: $e');
      rethrow;
    }
  }

  // Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      print('🔄 Intentando enviar email de recuperación a: $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Email de recuperación enviado exitosamente');
    } catch (e) {
      print('❌ Error al enviar email de recuperación: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } catch (e) {
      print('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  // Verificar si el usuario está autenticado
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  // Obtener mensaje de error amigable
  String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este email';
        case 'wrong-password':
          return 'Contraseña incorrecta';
        case 'email-already-in-use':
          return 'Este email ya está registrado';
        case 'invalid-email':
          return 'Email inválido';
        case 'weak-password':
          return 'La contraseña debe tener al menos 6 caracteres';
        case 'user-disabled':
          return 'Esta cuenta ha sido deshabilitada';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde';
        case 'operation-not-allowed':
          return 'Operación no permitida';
        case 'account-exists-with-different-credential':
          return 'Ya existe una cuenta con este email usando otro método';
        default:
          return 'Error: ${error.message}';
      }
    }
    return 'Error desconocido. Intenta nuevamente';
  }
}
