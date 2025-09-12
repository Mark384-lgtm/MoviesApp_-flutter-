import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/core/resources/AssetsManager.dart';
import 'package:movies_app/core/resources/ColorManager.dart';
import 'package:movies_app/data/model/MoviesDetailsResponse/Movie.dart';

import '../../../data/model/MoviesDetailsResponse/Cast.dart';

class CastItem extends StatelessWidget {
  Cast cast_data;

  CastItem(this.cast_data);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.navbarColor,
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: cast_data.urlSmallImage == null
                  ? SvgPicture.asset(
                      height: 70,
                      width: 70,
                      AssetsManager.profile,
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      height: 70,
                      width: 70,
                      cast_data.urlSmallImage!,
                      fit: BoxFit.fill,
                    ),
            ),

            SizedBox(width: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textAlign: TextAlign.start,
                      "name: ${cast_data.name!}",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                    Spacer(),
                    Text(
                      textAlign: TextAlign.start,
                      "caharcter: ${cast_data.characterName!}",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
