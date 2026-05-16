import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:random_teams_generator/providers/theme_provider.dart';
import 'ui/screens/home_screen.dart';

/// Entry point of the Random Teams Generator application.
/// Initializes the Riverpod [ProviderScope] and starts the app.
void main() {
  if (kDebugMode) {
    print('App: Starting Random Teams Generator');
  }
  
  // Wrap the entire app with ProviderScope to enable Riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ), // end of ProviderScope (Riverpod root)
  );
}

/// The root widget of the application.
/// Manages global theme state and primary navigation.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  /// Builds the [MaterialApp] with the current theme configuration.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the theme mode to update the UI on change
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      title: 'Random Teams Generator',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('it'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.outfitTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
      ),
      home: const HomeScreen(),
    ); // end of MaterialApp
  }
}

/// A simple loading screen used during application initialization.
class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  /// Builds the loading UI with a centered [CircularProgressIndicator].
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ), // end of Center (Loading indicator)
    ); // end of Scaffold (Initialization screen)
  }
}
