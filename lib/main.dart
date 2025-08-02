import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yoga_session_app/services/json_service.dart';
import 'core/constants/app_colors.dart';
import 'features/preview/views/preview_screen.dart';
import 'features/session/views/session_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final session = await JsonService().loadSessionData();
  print(session.title);
  runApp(const ProviderScope(child: YogaApp()));
}

class YogaApp extends StatelessWidget {
  const YogaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modular Yoga',
      theme: ThemeData(
        // Main colors
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
          onPrimary: Colors.white,
          onSecondary: AppColors.textDark,
          onBackground: AppColors.textDark,
        ),

        // AppBar style
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Text styles
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.textDark, fontSize: 16),
          bodyMedium: TextStyle(
            color: AppColors.textDark.withOpacity(0.8),
            fontSize: 14,
          ),
          headlineSmall: TextStyle(
            color: AppColors.primary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),

        // Chips (Tags, filters)
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.accent.withOpacity(0.2),
          labelStyle: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          selectedColor: AppColors.accent,
        ),
      ),
      routes: {
        '/': (_) => const PreviewScreen(),
        '/session': (_) => const SessionScreen(),
      },
    );
  }
}
