import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'core/theme/theme.dart';
import 'flutter_flow/flutter_flow_util.dart';

import 'modules/auth/infrastructure/services/auth_util.dart';
import 'modules/auth/infrastructure/services/auth_user_provider.dart'
    show AppVendedoresAuthUser, appVendedoresAuthUserStream;

import 'modules/clients/domain/services/client_service.dart';
import 'modules/clients/presentation/bloc/client_bloc.dart';
import 'modules/clients/presentation/bloc/client_event.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.configureDependencies();
  await GlobalTheme.initialize();
  await authManager.initialize();

  final appState = FFAppState();

  final clientService = ClientService();
  
  final getIt = GetIt.instance;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appState),
        Provider<ClientService>.value(value: clientService),
        BlocProvider(
          create: (context) => getIt<ClientBloc>()..add(LoadClients()),
          lazy: false, // Ensure it's created immediately
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = GlobalTheme.themeMode;
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late Stream<AppVendedoresAuthUser> userStream;

  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = appVendedoresAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    userStream.first.then((_) {
      _appStateNotifier.stopShowingSplashImage();
    });
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        GlobalTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AppVendedores',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
