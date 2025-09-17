import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movies/core/resources/RoutesManager.dart';


import '../../core/resources/AssetsManager.dart';
import '../../core/resources/ColorManager.dart';
import '../../core/reusable_components/custom_button.dart';
import '../../core/reusable_components/custom_switch.dart';
import '../../core/reusable_components/custom_textField.dart';
import 'forget_pass_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  int _selectedLanguage = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() =>
      setState(() => _obscurePassword = !_obscurePassword);

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, RouteManager.HomeScreen);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found')
        errorMessage = 'No user found with this email.';
      else if (e.code == 'wrong-password')
        errorMessage = 'Incorrect password.';
      else if (e.code == 'invalid-email')
        errorMessage = 'Invalid email address.';
      else if (e.code == 'user-disabled')
        errorMessage = 'This account has been disabled.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unexpected error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isGoogleLoading = true);
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isGoogleLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context,RouteManager.HomeScreen);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Google sign-in failed. Please try again.';
      if (e.code == 'account-exists-with-different-credential')
        errorMessage = 'Account exists with different credentials.';
      else if (e.code == 'invalid-credential')
        errorMessage = 'The Google credential is invalid or expired.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Google sign-in failed. Try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text("Login", style: TextStyle(color: ColorManager.yellow)),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: ColorManager.screen_background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 50),
              AssetsManager.Logo.endsWith('.svg')
                  ? SvgPicture.asset(AssetsManager.Logo)
                  : Image.asset(AssetsManager.Logo),
              const SizedBox(height: 25),
              CustomTextFormField(
                controller: _emailController,
                labelText: "Email",
                hintText: "Enter your email",
                iconAsset: AssetsManager.EmailIcon,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your email';
                  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value))
                    return 'Please enter a valid email';
                  return null;
                },
                inputFormatters: [],
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
                    color: Colors.white,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter your password';
                  if (value.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                },
                inputFormatters: [],
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteManager.forgetPassword),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: ColorManager.yellow),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: const Text("Login"),
                  onclick: _submitForm,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, RouteManager.register),
                    child: Text(
                      "Create One",
                      style: TextStyle(color: ColorManager.yellow),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(color: ColorManager.yellow),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: ColorManager.yellow),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: ColorManager.yellow),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isGoogleLoading ? null : _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: ColorManager.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isGoogleLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AssetsManager.GoogleIcon,
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Login with Google",
                              style: TextStyle(color: ColorManager.screen_background),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomSwitch(
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
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
