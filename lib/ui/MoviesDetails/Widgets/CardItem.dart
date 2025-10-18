import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/resources/ColorManager.dart';

class CardItem extends StatelessWidget {
  final String iconPath;
  final int count;

  const CardItem(this.iconPath, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;
        final isVerySmallScreen = constraints.maxWidth < 300;

        return Container(
          constraints: BoxConstraints(minWidth: isVerySmallScreen ? 80 : 90),
          decoration: BoxDecoration(
            color: ColorManager.navbarColor,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmallScreen
                ? 12
                : isSmallScreen
                ? 16
                : 22,
            vertical: isVerySmallScreen
                ? 8
                : isSmallScreen
                ? 10
                : 12,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: isVerySmallScreen
                    ? 14
                    : isSmallScreen
                    ? 16
                    : 20,
                height: isVerySmallScreen
                    ? 14
                    : isSmallScreen
                    ? 16
                    : 20,
              ),
              SizedBox(
                width: isVerySmallScreen
                    ? 6
                    : isSmallScreen
                    ? 8
                    : 14,
              ),
              Flexible(
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isVerySmallScreen
                        ? 12
                        : isSmallScreen
                        ? 14
                        : 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
