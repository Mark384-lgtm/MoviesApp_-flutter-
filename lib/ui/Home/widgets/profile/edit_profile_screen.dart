// ignore_for_file: unnecessary_import, use_build_context_synchronously, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/AssetsManager.dart';
import '../../../../core/resources/ColorManager.dart';
import '../../../../core/resources/RoutesManager.dart';
import '../../../../core/reusable_components/custom_button.dart';
import '../../../../core/reusable_components/custom_textField.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String phoneNumber;

  const EditProfileScreen({
    super.key,
    required this.userName,
    required this.phoneNumber,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _phoneController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Here you would typically save to database or API
      final newName = _nameController.text;
      final newPhone = _phoneController.text;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated: $newName, $newPhone'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ColorManager.screen_background,
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final user = _auth.currentUser;

      if (user != null) {
        // First, try to reauthenticate the user for security
        // You might want to add a reauthentication flow here
        // For example, prompt the user to enter their password again

        // Delete the user account from Firebase Authentication
        await user.delete();

        // Additional: Delete user data from Firestore or Realtime Database
        // await _deleteUserData(user.uid);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login screen or welcome screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login', // Replace with your login route
          (route) => false,
        );
      } else {
        throw Exception('No user logged in');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error deleting account';

      if (e.code == 'requires-recent-login') {
        errorMessage = 'Please log in again to delete your account';
        // You might want to implement a reauthentication flow here
      } else if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage: ${e.message}'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting account: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorManager.screen_background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorManager.screen_background,
        title: Text(
          'Edit Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            color: ColorManager.yellow,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorManager.yellow),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorManager.yellow,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AssetsManager.red_Avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorManager.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Form Fields using CustomTextFormField
              CustomTextFormField(
                controller: _nameController,
                labelText: 'Full Name',
                iconAsset: AssetsManager.profile,
                // You'll need to add this asset
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              CustomTextFormField(
                controller: _phoneController,
                labelText: 'Phone Number',
                iconAsset: AssetsManager.PhoneIcon,
                // You'll need to add this asset
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteManager.forgetPassword),
                  child: Text(
                    "Reset Password",
                    style: TextStyle(color: ColorManager.yellow, fontSize: 16),
                  ),
                ),
              ),

              const Spacer(),

              // Delete Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isDeleting
                      ? null
                      : _showDeleteAccountConfirmation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: ColorManager.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isDeleting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Delete Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Save Button using CustomButton
              Container(
                width: double.infinity,
                child: CustomButton(
                  title: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  onclick: _saveProfile,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
