// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/resources/AssetsManager.dart';
import '../../../../core/resources/ColorManager.dart';
import '../../../../core/resources/RoutesManager.dart';
import '../../../../core/reusable_components/custom_button.dart';
import '../../../../core/reusable_components/custom_textField.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isDeleting = false;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.user?.displayName ?? '',
    );
    _phoneController = TextEditingController(text: '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _profileImageUrl = widget.user?.photoURL;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        // Update display name
        if (_nameController.text.trim() != currentUser.displayName) {
          await currentUser.updateDisplayName(_nameController.text.trim());
        }

        // Update email if changed
        if (_emailController.text.trim() != currentUser.email) {
          await currentUser.verifyBeforeUpdateEmail(
            _emailController.text.trim(),
          );
        }

        // You can add phone number update logic here if using Firebase Auth phone auth
        // or store it in Firestore

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error updating profile';

      switch (e.code) {
        case 'requires-recent-login':
          errorMessage = 'Please re-authenticate to update your email.';
          break;
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'Error updating profile: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          duration: const Duration(seconds: 3),
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

  Future<void> _updateProfilePicture() async {
    // Implement profile picture update logic
    // This could involve:
    // 1. Image picker to select image from gallery/camera
    // 2. Upload image to Firebase Storage
    // 3. Update user's photoURL in Firebase Auth
    // 4. Update local state

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture update functionality to be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
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
        // Note: This requires recent authentication for security reasons
        // You might need to implement re-authentication flow

        await user.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteManager.login,
          (route) => false,
        );
      } else {
        throw Exception('No user logged in');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Error deleting account';

      if (e.code == 'requires-recent-login') {
        errorMessage =
            'Please log in again to delete your account. This is a security measure.';
        // You might want to implement a reauthentication flow here
        _showReauthenticationDialog();
      } else if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$errorMessage: ${e.message}'),
          duration: const Duration(seconds: 5),
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

  void _showReauthenticationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Re-authentication Required'),
          content: const Text(
            'For security reasons, please sign in again to delete your account.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _signOutAndReauthenticate();
              },
              child: const Text('Sign In Again'),
            ),
          ],
        );
      },
    );
  }

  void _signOutAndReauthenticate() async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteManager.login,
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during reauthentication: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 350;

            return Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
              child: Column(
                children: [
                  // Profile Picture Section
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: isSmallScreen ? 100 : 120,
                          height: isSmallScreen ? 100 : 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorManager.yellow,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child:
                                _profileImageUrl != null &&
                                    _profileImageUrl!.isNotEmpty
                                ? Image.network(
                                    _profileImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        AssetsManager.red_Avatar,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    AssetsManager.red_Avatar,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _updateProfilePicture,
                            child: Container(
                              width: isSmallScreen ? 32 : 40,
                              height: isSmallScreen ? 32 : 40,
                              decoration: BoxDecoration(
                                color: ColorManager.yellow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                                size: isSmallScreen ? 18 : 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Fields
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    iconAsset: AssetsManager.UserIcon,
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
                    controller: _emailController,
                    labelText: 'Email Address',
                    iconAsset: AssetsManager.EmailIcon,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  CustomTextFormField(
                    controller: _phoneController,
                    labelText: 'Phone Number (Optional)',
                    iconAsset: AssetsManager.PhoneIcon,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),

                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        RouteManager.forgetPassword,
                      ),
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                          color: ColorManager.yellow,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
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
                                  Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: isSmallScreen ? 20 : 25,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Delete Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 16 : 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      title: Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onclick: _saveProfile,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
