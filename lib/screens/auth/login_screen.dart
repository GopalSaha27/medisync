import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 45),

              //work MediSync icon...........
              Center(
                child: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medication_rounded,
                    size: 40,
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // work welcome text........
              const Center(
                child: Text(
                  'Welcome to MediSync',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //work subtitle.............
              Center(
                child: Text(
                  'Manage your medication with ease'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}