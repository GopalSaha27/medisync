import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
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
                  'Manage your medication with ease',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              SizedBox(height: 45),

              //work on email field..........
              const AppTextField(
                label: 'Email', 
                hint: 'Enter your email', 
                prefixIcon: Icons.email_outlined,
              ),

              const SizedBox(height: 18),

              //work on password field.....
              AppTextField(
                label: 'Password', 
                hint: 'Enter your paassword', 
                prefixIcon: Icons.lock_outline,
                obscureText:  _obscurePassword,//Password hide......
              ),

              SizedBox(height: 8),

              //work on forgot password button.........
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){

                  }, 
                  child: const Text(
                    'Forgot Password',
                  ),
                  ),
              ),

              SizedBox(height: 15),

              //work on login button..........
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: (){

                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
              ),

              SizedBox(height: 25),

              // Register Section...........
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                    ),

                    // work on register button..........
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                           MaterialPageRoute(
                            builder: (context) =>
                            const RegisterScreen(),
                            ),
                           );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}