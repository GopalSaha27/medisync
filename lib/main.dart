import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  // Make sure Flutter is initialized before using plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the notification service.
  await NotificationService.initialize();

  // Request notification permission from the user.
  await NotificationService.requestPermission();

  // Start the application.
  runApp(const MediSync());
}

class MediSync extends StatelessWidget {
  const MediSync({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner from the top-right corner.
      debugShowCheckedModeBanner: false,

      // Application title.
      title: 'MediSync',

      // Application theme.
      theme: ThemeData(
        // Enable Material 3 design.
        useMaterial3: true,

        // Create the color scheme using teal.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),

        // Set the default font.
        fontFamily: 'Roboto',
      ),

      // First screen of the application.
      home: const LoginScreen(),
    );
  }
}