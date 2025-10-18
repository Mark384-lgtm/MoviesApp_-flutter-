import 'package:flutter/material.dart';

import '../../../core/resources/ColorManager.dart';

class GenreItem extends StatelessWidget {
  final String genre;

  const GenreItem(this.genre, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorManager.navbarColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 12,
            vertical: isSmallScreen ? 8 : 12,
          ),
          child: Text(
            genre,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        );
      },
    );
  }
}
