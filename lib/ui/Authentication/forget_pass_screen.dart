// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, avoid_print, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/resources/AssetsManager.dart';
import '../../core/resources/ColorManager.dart';
import '../../core/reusable_components/custom_button.dart';
import '../../core/reusable_components/custom_textField.dart';



class ForgetPassword extends StatefulWidget {

  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      _emailFocusNode.requestFocus();
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Test Firebase connection first
      final auth = FirebaseAuth.instance;

      // Check if Firebase is properly initialized
      if (auth.app == null) {
        throw Exception('Firebase not initialized');
      }

      print('Sending password reset email to: ${_emailController.text.trim()}');

      // Send password reset email
      await auth.sendPasswordResetEmail(email: _emailController.text.trim());

      print('Password reset email sent successfully');

      // Success - email sent
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Password reset email has been sent! Check your inbox.',
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address format is invalid.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Too many attempts. Please try again in a few minutes.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        case 'missing-android-pkg-name':
        case 'missing-ios-bundle-id':
          errorMessage =
              'Firebase configuration error. Please contact support.';
          break;
        default:
          errorMessage = 'Failed to send reset email. Error: ${e.code}';
      }

      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red.shade700,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print('Unexpected error: $e');

      setState(() {
        _isLoading = false;
        _errorMessage = 'Configuration error: ${e.toString()}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Configuration error: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _navigateBack() {
    Navigator.pop(context);
  }

  void _tryAgain() {
    setState(() {
      _emailSent = false;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorManager.screen_background,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "Forgot Password",
          style: TextStyle(
            color: ColorManager.yellow,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: ColorManager.yellow,
          onPressed: _navigateBack,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image/Illustration
                AssetsManager.ForgetPass.endsWith('.svg')
                    ? SvgPicture.asset(
                        AssetsManager.ForgetPass,
                        height: screenHeight * 0.25,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        AssetsManager.ForgetPass,
                        height: screenHeight * 0.25,
                        fit: BoxFit.contain,
                      ),

                const SizedBox(height: 16),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade900.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade700),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade300),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade100,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Success message if email was sent
                if (_emailSent)
                  Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade400,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Check Your Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'ve sent a password reset link to your email address.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The link will expire in 1 hour.',
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              title: const Text("Back to Login"),
                              onclick: _navigateBack,
                              isLoading: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _tryAgain,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: ColorManager.yellow,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "Send Again",
                                style: TextStyle(
                                  color: ColorManager.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      // Instructions
                      Text(
                        'Reset Your Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your email address and we\'ll send you a link to reset your password',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Email field
                      CustomTextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        labelText: "Email Address",
                        hintText: "your.email@example.com",
                        iconAsset: AssetsManager.EmailIcon,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _resetPassword(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        inputFormatters: [],
                      ),
                      const SizedBox(height: 32),

                      // Reset button
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          title: const Text(
                            "Send Reset Link",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onclick: _resetPassword,
                          isLoading: _isLoading,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Additional help text
                if (!_emailSent)
                  Column(
                    children: [
                      Text(
                        "If you don't receive the email within a few minutes:",
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "• Check your spam folder\n• Verify you entered the correct email\n• Try again in a few minutes",
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
