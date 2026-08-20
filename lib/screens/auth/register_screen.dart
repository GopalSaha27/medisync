import 'package:flutter/material.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;// for hide password.......
  bool _obscureConfirmPassword = true; // for hide confirm password.......
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Create your MediSync account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Enter your information to get started.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 30),

            // for name field................
            const AppTextField(
              label: 'Full Name', 
              hint: 'Enter your name', 
              prefixIcon: Icons.person_outline,
            ),

            const SizedBox(height: 18),

            // for email field...........
            const AppTextField(
              label: 'Email', 
              hint: 'Enter your email', 
              prefixIcon: Icons.email_outlined,
            ),

            const SizedBox(height: 18),

            // for password field............
            AppTextField(
              label: 'Password', 
              hint: 'Create a password', 
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
            ),

            SizedBox(height: 18),

            // for confirm password............
            AppTextField(
              label: 'Confirm Password',
              hint: 'Re-enter your password',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscureConfirmPassword,
            ),

            SizedBox(height: 30),

            //for register button.............
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: (){

                }, 
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 20),

            //for back to login...........
            Center(
              child: TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  "Already have an account? Login"
                ),
              ),
            ),
          ],
        ),
        ),
        ),
    );
  }
}