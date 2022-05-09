import 'package:flutter/material.dart';

class ChipButton extends StatefulWidget {
  final Function() onPressed;
  final IconData icon;
  final String tooltipText;
  final bool disabled;

  const ChipButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.tooltipText,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<ChipButton> createState() => _ChipButtonState();
}

class _ChipButtonState extends State<ChipButton> {
  bool _isHover = false;
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: (widget.disabled) ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onHover: (_) => setState(() {
        _isHover = true;
      }),
      onExit: (_) => setState(() {
        _isHover = false;
      }),
      child: GestureDetector(
        onTap: widget.disabled ? null : widget.onPressed,
        onTapDown: widget.disabled ? null : (_) => setState(() => _isDown = true),
        onTapUp: widget.disabled ? null : (details) => setState(() => _isDown = false),
        onTapCancel: widget.disabled ? null : () => setState(() => _isDown = false),
        child: RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _calculateBackgroundColor(), 
              borderRadius: BorderRadius.circular(5)
            ),
            child: Icon(
              widget.icon,
              color: (widget.disabled) ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.5) : Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  _calculateBackgroundColor() {
    if(widget.disabled) {
      return Colors.transparent;
    }

    if(_isDown) {
      return const Color.fromRGBO(0, 0, 0, 0.4);
    } else if(_isHover) {
      return const Color.fromRGBO(0, 0, 0, 0.2);
    }

    return Colors.transparent;
  }
}