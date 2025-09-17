// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'MyApp.dart';
import 'core/remote/network/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MyApp());
}

// Add this to your main.dart after Firebase.initializeApp
void checkFirebaseConnection() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    print('Firebase connected. Current user: $user');
  } catch (e) {
    print('Firebase connection error: $e');
  }
}