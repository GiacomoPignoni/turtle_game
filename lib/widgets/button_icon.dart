import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  final Icon icon;
  final Function() onPressed;

  const ButtonIcon({
    required this.icon,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: icon,
      ),
    );
  }
}
