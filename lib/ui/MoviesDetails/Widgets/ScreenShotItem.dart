import 'package:flutter/cupertino.dart';

class ScreenShotItem extends StatelessWidget {
  String _pth;

  ScreenShotItem(this._pth);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(16),
          child: Image.network(
            height: 165,
            width: double.infinity,
            _pth,
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(height: 14),
      ],
    );
  }
}
