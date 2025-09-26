import 'package:rxdart/rxdart.dart';

export 'auth_manager.dart';

class AppVendedoresAuthUser {
  AppVendedoresAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Current user instance
AppVendedoresAuthUser? currentUser;

/// Generates a stream of the authenticated user.
final BehaviorSubject<AppVendedoresAuthUser> appVendedoresAuthUserSubject =
    BehaviorSubject.seeded(AppVendedoresAuthUser(loggedIn: false));

/// Stream of authentication state changes
Stream<AppVendedoresAuthUser> appVendedoresAuthUserStream() =>
    appVendedoresAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
