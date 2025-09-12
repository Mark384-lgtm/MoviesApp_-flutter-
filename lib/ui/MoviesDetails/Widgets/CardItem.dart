import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/core/resources/ColorManager.dart';

class CardItem extends StatelessWidget {
  String _iconpth;
  int count;

  CardItem(this._iconpth,this.count);
  @override
  Widget build(BuildContext context) {
   return   Container(
     decoration: BoxDecoration(
       color: ColorManager.navbarColor,
       borderRadius: BorderRadiusGeometry.circular(16),
     ),
     child: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 22),
       child: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           SvgPicture.asset(_iconpth),
           SizedBox(width: 14,),
           Text(count.toString()),
         ],
       ),
     ),
   );
  }

}