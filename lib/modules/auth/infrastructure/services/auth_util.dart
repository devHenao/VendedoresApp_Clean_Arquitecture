// Importar solo lo necesario para evitar exportaciones duplicadas
import 'auth_manager.dart';
import 'auth_user_provider.dart';

// Exportar solo lo necesario
export 'auth_manager.dart' show AuthManager;
export 'auth_user_provider.dart' show AppVendedoresAuthUser, currentUser;

// Instancia única del administrador de autenticación
final authManager = AuthManager();

// Getters para acceder a la información de autenticación
String get currentUserUid => currentUser?.uid ?? '';
String? get currentAuthenticationToken => authManager.authenticationToken;
String? get currentAuthRefreshToken => authManager.refreshToken;
DateTime? get currentAuthTokenExpiration => authManager.tokenExpiration;
