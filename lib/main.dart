import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized before using Firebase and plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the notification service.
  await NotificationService.initialize();

  // Request notification permission.
  await NotificationService.requestPermission();

  // Start the application.
  runApp(const MediSync());
}

class MediSync extends StatelessWidget {
  const MediSync({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner.
      debugShowCheckedModeBanner: false,

      // Application title.
      title: 'MediSync',

      // Application theme.
      theme: ThemeData(
        // Enable Material 3 design.
        useMaterial3: true,

        // Create the application color scheme.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),

        // Set the default application font.
        fontFamily: 'Roboto',
      ),

      // Set the first screen of the application.
      home: const LoginScreen(),
    );
  }
}