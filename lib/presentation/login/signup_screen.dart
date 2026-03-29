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
    print("Sign up button pressed");
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      return;
    }
    if (!Provider.of<ConnectivityProvider>(
      context,
      listen: false,
    ).checkConnectionAndNotify(context)) {
      print("Connectivity check failed");
      return;
    }
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
    print("User object created: ${user.toJson()}");
    final res = await AuthService().signUp(user, _pass.text);
    print("AuthService signUp returned status: ${res.status}");
    setState(() => _isLoading = false);
    if (res.status == Status.COMPLETED && mounted)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (c) => const MainScreen()),
      );
    else if (mounted)
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res.message ?? "Sign Up Failed")));
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
                  Text(
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
                    child: Text(
                      AppStrings.haveAccount,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
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
      _buildGenderSelection(),
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

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            "Select Gender",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _genderCard("male", Icons.male, "Male"),
            _genderCard("female", Icons.female, "Female"),
            _genderCard("other", Icons.transgender, "Other"),
          ],
        ),
      ],
    );
  }

  Widget _genderCard(String value, IconData icon, String label) {
    bool isSelected = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.white.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton() => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _signUp,
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
              AppStrings.signUp,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    ),
  );
}
