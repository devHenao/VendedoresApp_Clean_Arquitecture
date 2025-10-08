import 'package:rxdart/rxdart.dart';

export 'auth_manager.dart';

class AppVendedoresAuthUser {
  AppVendedoresAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

AppVendedoresAuthUser? currentUser;

final BehaviorSubject<AppVendedoresAuthUser> appVendedoresAuthUserSubject =
    BehaviorSubject.seeded(AppVendedoresAuthUser(loggedIn: false));

Stream<AppVendedoresAuthUser> appVendedoresAuthUserStream() =>
    appVendedoresAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
