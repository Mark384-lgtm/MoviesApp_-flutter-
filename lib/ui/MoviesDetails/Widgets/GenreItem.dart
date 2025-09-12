import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/resources/ColorManager.dart';

class GenreItem extends StatelessWidget {
  String genre;

  GenreItem(this.genre);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  height: 36,
      //width: 122,
      //padding: EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorManager.navbarColor,
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      child: Text(
        maxLines: 1,
        textAlign: TextAlign.center,
        genre,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
    );
  }
}
