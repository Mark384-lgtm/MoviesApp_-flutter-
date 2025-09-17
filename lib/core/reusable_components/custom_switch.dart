import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';

import '../resources/ColorManager.dart';



class CustomSwitch extends StatefulWidget {
  final List<Widget> icons;
  final int current;
  final Function(int) onChange;
  final double? width;

  const CustomSwitch({
    super.key,
    required this.icons,
    required this.current,
    required this.onChange,
    this.width,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.current;
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.current != current) {
      setState(() {
        current = widget.current;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 110,
      child: AnimatedToggleSwitch<int>.rolling(
        onChanged: (value) {
          setState(() {
            current = value;
          });
          widget.onChange(value);
        },
        current: current,
        values: const [0, 1],
        iconOpacity: 0.6,
        indicatorTransition: ForegroundIndicatorTransition.rolling(),
        style: ToggleStyle(
          backgroundColor: Colors.transparent,
          indicatorColor: ColorManager.yellow,
          borderColor: ColorManager.yellow,
        ),
        iconList: widget.icons,
      ),
    );
  }
}
