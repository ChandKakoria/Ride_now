import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:sakhi_yatra/presentation/main_screen.dart';
import 'package:sakhi_yatra/services/auth_service.dart';
import 'package:sakhi_yatra/core/api_response.dart';
import 'package:sakhi_yatra/core/models/user_model.dart';
import 'package:sakhi_yatra/presentation/widgets/glass_text_field.dart';
import 'package:sakhi_yatra/core/app_strings.dart';
import 'package:sakhi_yatra/presentation/widgets/auth_background.dart';
import 'package:sakhi_yatra/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _email = TextEditingController(),
      _pass = TextEditingController(),
      _first = TextEditingController(),
      _last = TextEditingController(),
      _phone = TextEditingController(),
      _dob = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedGender = 'female';

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!Provider.of<ConnectivityProvider>(
      context,
      listen: false,
    ).checkConnectionAndNotify(context))
      return;
    setState(() => _isLoading = true);
    final user = UserModel(
      id: '',
      email: _email.text,
      firstName: _first.text,
      lastName: _last.text,
      phoneNumber: _phone.text,
      dob: _dob.text,
      gender: _selectedGender,
    );
    final res = await AuthService().signUp(user, _pass.text);
    setState(() => _isLoading = false);
    if (res.status == Status.COMPLETED && mounted)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const MainScreen()),
      );
    else if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message ?? "Sign Up Failed"),
          backgroundColor: Colors.red,
        ),
      );
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
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    AppStrings.createAccount,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFields(),
                  const SizedBox(height: 48),
                  _buildButton(),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      AppStrings.haveAccount,
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
    );
  }

  Widget _buildFields() => Column(
    children: [
      GlassTextField(
        controller: _first,
        hintText: 'First Name',
        icon: Icons.person_outline,
        validator: (v) =>
            (v == null || v.isEmpty) ? AppStrings.requiredField : null,
      ),
      const SizedBox(height: 16),
      GlassTextField(
        controller: _last,
        hintText: 'Last Name',
        icon: Icons.person_outline,
        validator: (v) =>
            (v == null || v.isEmpty) ? AppStrings.requiredField : null,
      ),
      const SizedBox(height: 16),
      GlassTextField(
        controller: _email,
        hintText: 'Email',
        icon: Icons.email_outlined,
        validator: (v) =>
            (v == null || !v.contains('@')) ? AppStrings.invalidField : null,
      ),
      const SizedBox(height: 16),
      GlassTextField(
        controller: _phone,
        hintText: 'Phone Number',
        icon: Icons.phone_outlined,
        inputType: TextInputType.phone,
        validator: (v) =>
            (v == null || v.length < 10) ? AppStrings.tooShort : null,
      ),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now().subtract(
              const Duration(days: 365 * 18),
            ),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            setState(() {
              _dob.text =
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            });
          }
        },
        child: AbsorbPointer(
          child: GlassTextField(
            controller: _dob,
            hintText: 'Date of Birth (YYYY-MM-DD)',
            icon: Icons.calendar_today_outlined,
            validator: (v) =>
                (v == null || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(v))
                ? AppStrings.dobFormatReq
                : null,
          ),
        ),
      ),
      const SizedBox(height: 16),
      _buildFemaleGenderCard(),
      const SizedBox(height: 16),
      GlassTextField(
        controller: _pass,
        hintText: 'Password',
        icon: Icons.lock_outline,
        isPassword: true,
        validator: (v) =>
            (v == null || v.length < 6) ? AppStrings.min6Chars : null,
      ),
    ],
  );

  Widget _buildFemaleGenderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.female, color: Colors.white, size: 24),
          ),
          Text(
            "Gender: Female",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF00A3E0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Color(0xFF00A3E0))
          : const Text(
              AppStrings.signUp,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    ),
  );
}
