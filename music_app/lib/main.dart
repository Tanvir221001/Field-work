import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/search_screen.dart';
import 'presentation/screens/library_screen.dart';
import 'presentation/screens/detail_screen.dart';
import 'presentation/screens/profile_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/settings/account_details_screen.dart';
import 'presentation/screens/settings/privacy_security_screen.dart';
import 'presentation/screens/settings/subscription_screen.dart';
import 'presentation/screens/settings/appearance_screen.dart';
import 'presentation/screens/settings/language_screen.dart';
import 'presentation/screens/settings/listening_history_screen.dart';
import 'presentation/screens/settings/data_saver_screen.dart';
import 'presentation/screens/settings/audio_quality_screen.dart';
import 'presentation/screens/settings/notifications_screen.dart';
import 'presentation/screens/create_profile_screen.dart';
import 'domain/entities/song.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'dart:io' as io;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (io.Platform.isWindows || io.Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Router configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        int index = 0;
        if (state.uri.path.startsWith('/home')) index = 0;
        if (state.uri.path.startsWith('/search')) index = 1;
        if (state.uri.path.startsWith('/library')) index = 2;
        if (state.uri.path.startsWith('/profile')) index = 3;
        
        return MainScreen(
          currentIndex: index,
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) => const NoTransitionPage(child: SearchScreen()),
        ),
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) => const NoTransitionPage(child: LibraryScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final song = state.extra as Song;
        return MusicDetailScreen(song: song);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/create_profile',
      builder: (context, state) => const CreateProfileScreen(),
    ),
    GoRoute(
      path: '/settings/account',
      builder: (context, state) => const AccountDetailsScreen(),
    ),
    GoRoute(
      path: '/settings/privacy',
      builder: (context, state) => const PrivacySecurityScreen(),
    ),
    GoRoute(
      path: '/settings/subscription',
      builder: (context, state) => const SubscriptionScreen(),
    ),
    GoRoute(
      path: '/settings/appearance',
      builder: (context, state) => const AppearanceScreen(),
    ),
    GoRoute(
      path: '/settings/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/settings/history',
      builder: (context, state) => const ListeningHistoryScreen(),
    ),
    GoRoute(
      path: '/settings/data',
      builder: (context, state) => const DataSaverScreen(),
    ),
    GoRoute(
      path: '/settings/audio',
      builder: (context, state) => const AudioQualityScreen(),
    ),
    GoRoute(
      path: '/settings/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Luxury Music',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark, // Always dark as per requirements
          routerConfig: _router,
        );
      },
    );
  }
}
