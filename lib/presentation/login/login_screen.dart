import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:sakhi_yatra/presentation/main_screen.dart';
import 'package:sakhi_yatra/presentation/login/signup_screen.dart';
import 'package:sakhi_yatra/presentation/login/forgot_password_screen.dart';
import 'package:sakhi_yatra/services/auth_service.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/presentation/widgets/glass_text_field.dart';
import 'package:sakhi_yatra/core/app_strings.dart';
import 'package:sakhi_yatra/presentation/widgets/auth_background.dart';
import 'package:sakhi_yatra/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(),
      _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (!Provider.of<ConnectivityProvider>(
      context,
      listen: false,
    ).checkConnectionAndNotify(context))
      return;
    setState(() => _isLoading = true);
    final res = await AuthService().login(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _isLoading = false);
    if (res.status == Status.COMPLETED && mounted)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const MainScreen()),
      );
    else if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res.message ?? "Login Failed")));
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.welcomeBack,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.signInToContinue,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 48),
                  GlassTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                    validator: (v) => (v == null || !v.contains('@'))
                        ? AppStrings.validEmailReq
                        : null,
                  ),
                  const SizedBox(height: 24),
                  GlassTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    validator: (v) => (v == null || v.isEmpty)
                        ? AppStrings.passwordReq
                        : null,
                  ),
                  const SizedBox(height: 48),
                  _buildButton(),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const SignUpScreen()),
                    ),
                    child: Text(
                      AppStrings.noAccount,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : null,
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Theme.of(context).primaryColor)
          : const Text(
              AppStrings.signIn,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    ),
  );
}
