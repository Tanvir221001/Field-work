import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import '../../presentation/screens/splash_screen.dart';
// import '../../presentation/screens/main_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Splash Screen'))), // Placeholder
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Main Screen'))), // Placeholder
      ),
    ],
  );
}
