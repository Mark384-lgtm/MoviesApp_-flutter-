import 'package:flutter/material.dart';

import '../resources/ColorManager.dart';


class CustomButton extends StatelessWidget {
  final Widget title;
  final VoidCallback onclick;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.title,
    required this.onclick,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onclick,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: ColorManager.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : DefaultTextStyle.merge(
              style: const TextStyle(
                color: ColorManager.screen_background,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              child: title,
            ),
    );
  }
}
