// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/resources/RoutesManager.dart';

import '../../core/resources/AssetsManager.dart';
import '../../core/resources/ColorManager.dart';
import '../../core/reusable_components/custom_button.dart';
import '../../core/reusable_components/custom_switch.dart';
import '../../core/reusable_components/custom_textField.dart';


class RegisterScreen extends StatefulWidget {


  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  int _selectedLanguage = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;
  int _selectedAvatarIndex = 0;

  final List<String> _avatarAssets = [
    AssetsManager.air_phones_avatar,
    AssetsManager.badla_avatar,
    AssetsManager.cat_girl_avatar,
    AssetsManager.da2n_avatar,
    AssetsManager.gamer_girl_avatar,
    AssetsManager.green_avatar,
    AssetsManager.red_Avatar,
    AssetsManager.yellow_avatar,
    AssetsManager.yellow_hair_girl_avatar,
  ];

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept terms and conditions')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(
          _nameController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        Navigator.pushReplacementNamed(context, RouteManager.HomeScreen);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration failed. Please try again.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use')
        errorMessage = 'An account already exists for that email.';
      else if (e.code == 'invalid-email')
        errorMessage = 'The email address is not valid.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final cleanedValue = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanedValue.length < 8) return 'Phone number too short';
    if (cleanedValue.length > 15) return 'Phone number too long';
    final phoneRegex = RegExp(r'^(\+?[\d]{1,4})?[\d]{8,15}$');
    if (!phoneRegex.hasMatch(cleanedValue)) return 'Invalid phone format';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.screen_background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          'Register',
          style: TextStyle(
            color: ColorManager.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          color: ColorManager.yellow,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 32, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Avatar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: ColorManager.textFieldColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: List.generate(_avatarAssets.length, (
                            index,
                          ) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedAvatarIndex = index),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedAvatarIndex == index
                                        ? ColorManager.yellow
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: _selectedAvatarIndex == index
                                      ? [
                                          BoxShadow(
                                            color: ColorManager.yellow
                                                .withOpacity(0.4),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(45),
                                      child: Image.asset(
                                        _avatarAssets[index],
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 70,
                                                height: 70,
                                                color: Colors.grey[800],
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.grey[500],
                                                  size: 30,
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    if (_selectedAvatarIndex == index)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: ColorManager.yellow,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: ColorManager
                                                  .screen_background,
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: ColorManager.screen_background,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              CustomTextFormField(
                controller: _nameController,
                labelText: "Full Name",
                hintText: "Enter your full name",
                iconAsset: AssetsManager.UserIcon,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Name is required';
                  if (value.length < 3)
                    return 'Name must be at least 3 characters';
                  if (value.length > 50) return 'Name too long';
                  return null;
                },
                inputFormatters: [],
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                controller: _emailController,
                labelText: "Email",
                hintText: "Enter your email",
                iconAsset: AssetsManager.EmailIcon,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value))
                    return 'Invalid email format';
                  return null;
                },
                inputFormatters: [],
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                controller: _phoneController,
                labelText: "Phone Number",
                hintText: "Enter your phone number",
                iconAsset: AssetsManager.PhoneIcon,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                validator: _validatePhoneNumber,
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                controller: _passwordController,
                labelText: "Password",
                hintText: "Enter your password",
                iconAsset: AssetsManager.PassIcon,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[400],
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Password is required';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
                  if (!RegExp(r'[0-9]').hasMatch(value))
                    return 'Password requires a number';
                  if (!RegExp(r'[A-Za-z]').hasMatch(value))
                    return 'Password requires a letter';
                  return null;
                },
                inputFormatters: [],
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                controller: _confirmPasswordController,
                labelText: "Confirm Password",
                hintText: "Confirm your password",
                iconAsset: AssetsManager.PassIcon,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey[400],
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please confirm your password';
                  if (value != _passwordController.text)
                    return 'Passwords do not match';
                  return null;
                },
                inputFormatters: [],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) =>
                        setState(() => _termsAccepted = value ?? false),
                    checkColor: ColorManager.screen_background,
                    activeColor: ColorManager.screen_background,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'I agree to terms and conditions',
                        style: TextStyle(
                          color: ColorManager.yellow,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomButton(
                title: const Text(
                  "Create Account",
                  style: TextStyle(
                    color: ColorManager.screen_background,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onclick: _register,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      RouteManager.login,
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: ColorManager.yellow,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Center(
                child: Column(
                  children: [
                    Text(
                      "Select Language",
                      style: TextStyle(
                        color: ColorManager.yellow,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomSwitch(
                      onChange: (value) =>
                          setState(() => _selectedLanguage = value),
                      icons: [
                        SvgPicture.asset(
                          AssetsManager.English,
                          height: 30,
                          width: 30,
                        ),
                        SvgPicture.asset(
                          AssetsManager.Arabic,
                          height: 30,
                          width: 30,
                        ),
                      ],
                      current: _selectedLanguage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
