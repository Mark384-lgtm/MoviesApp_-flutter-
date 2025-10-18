import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/resources/AssetsManager.dart';
import '../../../../../core/resources/ColorManager.dart';

class SearchField extends StatefulWidget {
  final void Function(String? term) getQueryTerm;
  final String? text;

  const SearchField(this.getQueryTerm, this.text, {super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.text = widget.text ?? "";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 350;

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
                widget.getQueryTerm(_controller.text);
              },
              icon: SvgPicture.asset(
                AssetsManager.search,
                width: isSmallScreen ? 18 : 24,
                height: isSmallScreen ? 18 : 24,
              ),
            ),
            hintText: "Search movies...",
            hintStyle: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontSize: isSmallScreen ? 14 : 16,
          ),
          onSubmitted: (value) {
            widget.getQueryTerm(value);
          },
        );
      },
    );
  }
}
