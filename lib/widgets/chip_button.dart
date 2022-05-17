import 'package:flutter/material.dart';

class ChipButton extends StatefulWidget {
  final Function() onPressed;
  final IconData icon;
  final String tooltipText;
  final bool disabled;
  final double iconSize;

  const ChipButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.tooltipText,
    this.iconSize = 20,
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
    final theme = Theme.of(context);

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
            height: widget.iconSize + 10,
            constraints: const BoxConstraints(minHeight: 15, minWidth: 40),
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _calculateBackgroundColor(theme), 
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: theme.dividerTheme.color!.withOpacity(0.2), width: theme.dividerTheme.thickness!)
            ),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: (widget.disabled) ? theme.colorScheme.onSecondary.withOpacity(0.5) : theme.colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Color _calculateBackgroundColor(ThemeData theme) {
    if(widget.disabled) {
      return Colors.transparent;
    }

    if(_isDown) {
      final hslColor = HSLColor.fromColor(theme.colorScheme.secondary);
      return hslColor.withLightness((hslColor.lightness - 0.2).clamp(0.0, 1.0)).toColor();
    } else if(_isHover) {
      final hslColor = HSLColor.fromColor(theme.colorScheme.secondary);
      return hslColor.withLightness((hslColor.lightness - 0.1).clamp(0.0, 1.0)).toColor();
    }

    return theme.colorScheme.secondary;
  }
}
