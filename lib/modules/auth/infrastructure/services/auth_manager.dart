import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_user_provider.dart';

export 'auth_manager.dart';

const _kAuthTokenKey = '_auth_authentication_token_';
const _kRefreshTokenKey = '_auth_refresh_token_';
const _kTokenExpirationKey = '_auth_token_expiration_';
const _kUidKey = '_auth_uid_';

class AuthManager {
  // Auth session attributes
  String? authenticationToken;
  String? refreshToken;
  DateTime? tokenExpiration;
  // User attributes
  String? uid;

  Future signOut() async {
    authenticationToken = null;
    refreshToken = null;
    tokenExpiration = null;
    uid = null;

    // Update the current user.
    appVendedoresAuthUserSubject.add(
      AppVendedoresAuthUser(loggedIn: false),
    );
    await persistAuthData();
  }

  Future<AppVendedoresAuthUser?> signIn({
    String? authenticationToken,
    String? refreshToken,
    DateTime? tokenExpiration,
    String? uid,
  }) async {
    this.authenticationToken = authenticationToken;
    this.refreshToken = refreshToken;
    this.tokenExpiration = tokenExpiration;
    this.uid = uid;

    final user = AppVendedoresAuthUser(
      loggedIn: true,
      uid: uid,
    );

    appVendedoresAuthUserSubject.add(user);
    await persistAuthData();
    return user;
  }

  Future<void> persistAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAuthTokenKey, authenticationToken ?? '');
    await prefs.setString(_kRefreshTokenKey, refreshToken ?? '');
    await prefs.setString(
      _kTokenExpirationKey,
      tokenExpiration?.toIso8601String() ?? '',
    );
    await prefs.setString(_kUidKey, uid ?? '');
  }

  Future<void> loadFromPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    authenticationToken = prefs.getString(_kAuthTokenKey);
    refreshToken = prefs.getString(_kRefreshTokenKey);
    final tokenExpirationString = prefs.getString(_kTokenExpirationKey);
    if (tokenExpirationString?.isNotEmpty ?? false) {
      tokenExpiration = DateTime.tryParse(tokenExpirationString!);
    }
    uid = prefs.getString(_kUidKey);

    if (authenticationToken?.isNotEmpty ?? false) {
      appVendedoresAuthUserSubject.add(
        AppVendedoresAuthUser(
          loggedIn: true,
          uid: uid,
        ),
      );
    } else {
      appVendedoresAuthUserSubject.add(
        AppVendedoresAuthUser(loggedIn: false),
      );
    }
  }

  Future<void> initialize() async {
    await loadFromPersistedData();
  }
}

final authManager = AuthManager();
