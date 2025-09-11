import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/resources/AssetsManager.dart';
import 'package:movies_app/core/resources/ColorManager.dart';

class MovieItem extends StatelessWidget {
  String imgPath;
  num? rating;

  MovieItem({required this.imgPath , this.rating});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        //alignment: Alignment.topLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(16),
            child: Image.network(imgPath, fit: BoxFit.fitHeight),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            margin: EdgeInsets.only(top: 5, left: 5),
            height: 28,
            decoration: BoxDecoration(
              color: ColorManager.screen_background.withOpacity(0.7),
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rating.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white),
                ),
                SizedBox(width: 5,),
                Icon(Icons.star,color: ColorManager.yellow,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
