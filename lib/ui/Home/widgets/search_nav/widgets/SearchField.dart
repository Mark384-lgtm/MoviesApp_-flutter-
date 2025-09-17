import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/resources/AssetsManager.dart';
import '../../../../../core/resources/ColorManager.dart';

class SearchField extends StatefulWidget {
  void Function(String? term) get_Querterm;
  SearchField(this.get_Querterm ,this.text);
  String? text;
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller=TextEditingController();
    _controller.text=widget.text==null?"":widget.text!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        fillColor: ColorManager.navbarColor,
        filled: true,
        prefixIcon: IconButton(
          onPressed: () {
            setState(() {
              widget.get_Querterm(_controller.text);
            });
          },
          icon: SvgPicture.asset(AssetsManager.search),
        ),
      ),
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.white),
    );
  }
}
