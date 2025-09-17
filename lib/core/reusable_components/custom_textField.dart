// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/ColorManager.dart';



class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String iconAsset;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.iconAsset,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.hintText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: iconAsset.endsWith('.svg')
              ? SvgPicture.asset(
                  iconAsset,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  height: 24,
                  width: 24,
                )
              : Image.asset(
                  iconAsset,
                  color: Colors.white,
                  height: 24,
                  width: 24,
                ),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorManager.yellow),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
