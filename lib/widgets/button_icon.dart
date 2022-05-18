import 'package:flutter/material.dart';

class ButtonIcon extends StatefulWidget {
  final Icon icon;
  final Function() onPressed;

  const ButtonIcon({
    required this.icon,
    required this.onPressed,
    Key? key
  }) : super(key: key);

  @override
  State<ButtonIcon> createState() => _ButtonIconState();
}

class _ButtonIconState extends State<ButtonIcon> {
  bool _isDown = false;
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 250),
      scale: _isDown ? 0.9 : _isHover ? 1.1 : 1,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHover = true),
        onHover: (_) => setState(() => _isHover = true),
        onExit: (_) => setState(() => _isHover = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isDown = true),
          onTapCancel: () => setState(() => _isDown = false),
          onTapUp: (_) => setState(() => _isDown = false),
          onTap: widget.onPressed,
          child: widget.icon,
        ),
      ),
    );
  }
}
