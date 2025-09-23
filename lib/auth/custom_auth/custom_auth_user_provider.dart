import 'package:rxdart/rxdart.dart';
import 'custom_auth_manager.dart';

class AppVendedoresAuthUser {
  AppVendedoresAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<AppVendedoresAuthUser> appVendedoresAuthUserSubject =
    BehaviorSubject.seeded(AppVendedoresAuthUser(loggedIn: false));
Stream<AppVendedoresAuthUser> appVendedoresAuthUserStream() =>
    appVendedoresAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
