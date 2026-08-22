import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final IconData? suffixIcon;
  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,

    this.obscureText = false,
    this.onSuffixIconPressed,
    this.suffixIcon,
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),

        
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onSuffixIconPressed,
                icon: Icon(suffixIcon),
              )
              : null,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.teal,
          ),
        ),      
      ),
    );
  }
}