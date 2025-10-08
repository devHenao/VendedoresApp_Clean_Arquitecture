import 'auth_user_provider.dart';

export 'auth_manager.dart' show AuthManager;
export 'auth_user_provider.dart' show AppVendedoresAuthUser, currentUser;

final authManager = AuthManager();

String get currentUserUid => currentUser?.uid ?? '';
String? get currentAuthenticationToken => authManager.authenticationToken;
String? get currentAuthRefreshToken => authManager.refreshToken;
DateTime? get currentAuthTokenExpiration => authManager.tokenExpiration;
