import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:ride_now/presentation/main_screen.dart';

import 'package:ride_now/services/auth_service.dart';
import 'package:ride_now/core/api_response.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dobController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final response = await _authService.signUp(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      phoneNumber: _phoneNumberController.text,
      dob: _dobController.text,
    );

    setState(() => _isLoading = false);

    if (response.status == Status.COMPLETED) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Sign Up Failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Same as Login)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
          ),
          // ... (Decorative circles omitted for brevity in replace block if unchanged, but since I'm replacing the whole file content structure mostly, I'll keep them)
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    constraints: const BoxConstraints(maxWidth: 500),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign up to get started',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildGlassTextField(
                            controller: _firstNameController,
                            hintText: 'First Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'First Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildGlassTextField(
                            controller: _lastNameController,
                            hintText: 'Last Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Last Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildGlassTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildGlassTextField(
                            controller: _phoneNumberController,
                            hintText: 'Phone Number',
                            icon: Icons.phone_outlined,
                            inputType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone Number is required';
                              }
                              if (value.length < 10) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildGlassTextField(
                            controller: _dobController,
                            hintText: 'Date of Birth (YYYY-MM-DD)',
                            icon: Icons.calendar_today_outlined,
                            inputType: TextInputType.datetime,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date of Birth is required';
                              }
                              // Regex for YYYY-MM-DD
                              final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                              if (!regex.hasMatch(value)) {
                                return 'Enter format YYYY-MM-DD';
                              }
                              // Validate actual date
                              try {
                                DateTime.parse(value);
                              } catch (e) {
                                return 'Invalid date';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildGlassTextField(
                            controller: _passwordController,
                            hintText: 'Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 48),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF764BA2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 5,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF764BA2),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Already have an account? Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType? inputType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: inputType,
        style: const TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
        cursorColor: Colors.white,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white60),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          errorStyle: const TextStyle(color: Colors.orangeAccent),
        ),
      ),
    );
  }
}
