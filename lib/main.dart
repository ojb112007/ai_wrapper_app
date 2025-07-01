// lib/main.dart
import 'package:ai_wrapper_app/model/chat_message_model.dart';
import 'package:ai_wrapper_app/routing/app_router.dart';
import 'package:ai_wrapper_app/services/typing_text_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: AIWrapperApp()));
}

class AIWrapperApp extends StatelessWidget {
  const AIWrapperApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'AI Wrapper App',
      theme: ThemeData(
        // Change app color scheme to a darker theme
        primaryColor: const Color(0xFF2C3E50),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF2C3E50),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF303030),
          secondary: const Color(0xFF0B93F6),
          surface: const Color(0xFF2C3E50),
          background: const Color(0xFF34495E),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C3E50),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          fillColor: const Color(0xFF2C3E50),
          filled: true,
        ),
      ),
      darkTheme: ThemeData.dark(),
    );
  }
}
