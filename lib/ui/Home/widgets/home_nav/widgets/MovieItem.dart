
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/resources/AssetsManager.dart';

class MovieItem extends StatelessWidget {

  String imgPath;
  MovieItem({required this.imgPath});
  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset(imgPath,fit: BoxFit.fill,));
  }

}