import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/resources/AssetsManager.dart';
import '../../../core/resources/ColorManager.dart';
import '../../../data/model/MoviesDetailsResponse/Cast.dart';

class CastItem extends StatelessWidget {
  final Cast castData;

  const CastItem(this.castData, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorManager.navbarColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 8.0 : 12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: castData.urlSmallImage == null
                      ? SvgPicture.asset(
                          AssetsManager.profile,
                          height: isSmallScreen ? 50 : 70,
                          width: isSmallScreen ? 50 : 70,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          castData.urlSmallImage!,
                          height: isSmallScreen ? 50 : 70,
                          width: isSmallScreen ? 50 : 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return SvgPicture.asset(
                              AssetsManager.profile,
                              height: isSmallScreen ? 50 : 70,
                              width: isSmallScreen ? 50 : 70,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
                SizedBox(width: isSmallScreen ? 8 : 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "name: ${castData.name ?? 'Unknown'}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 4 : 8),
                      Text(
                        "character: ${castData.characterName ?? 'Unknown'}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
