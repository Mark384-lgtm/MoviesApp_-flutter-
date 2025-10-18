// ignore_for_file: use_build_context_synchronously, deprecated_member_use

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
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

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
      setState(() {
        _isLoading = false;
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('An unexpected error occurred.'),
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 350;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : 24,
                vertical: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight * 0.22,
                      child: AssetsManager.ForgetPass.endsWith('.svg')
                          ? SvgPicture.asset(
                              AssetsManager.ForgetPass,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              AssetsManager.ForgetPass,
                              fit: BoxFit.contain,
                            ),
                    ),
                    const SizedBox(height: 24),

                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
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
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'We\'ve sent a password reset link to your email address.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              title: Text(
                                "Back to Login",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                ),
                              ),
                              onclick: _navigateBack,
                              isLoading: false,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _tryAgain,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(color: ColorManager.yellow),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                "Send Again",
                                style: TextStyle(
                                  color: ColorManager.yellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 16 : 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Text(
                            'Reset Your Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 20 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your email address and we\'ll send you a link to reset your password',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

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

                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              title: Text(
                                "Send Reset Link",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isSmallScreen ? 16 : 18,
                                ),
                              ),
                              onclick: _resetPassword,
                              isLoading: _isLoading,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 24),

                    if (!_emailSent)
                      Column(
                        children: [
                          Text(
                            "If you don't receive the email within a few minutes:",
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: isSmallScreen ? 12 : 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "• Check your spam folder\n• Verify you entered the correct email\n• Try again in a few minutes",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: isSmallScreen ? 11 : 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
