import 'package:flutter/material.dart';

class ResizableContainerConsts {
  static const double toggleContainerHeight = 12;
  static const double toggleHeight = 6;
  static const double toggleWidth = 30;
}

class ResizableContainer extends StatefulWidget {
  final Widget child;
  final double initialHeight;
  final double maxHeight;
  final double minHeight;
  final Color? backgroundColor;
  final Color? toggleColor;

  const ResizableContainer({
    required this.child,
    required this.initialHeight,
    required this.maxHeight,
    required this.minHeight,
    this.toggleColor = Colors.black,
    this.backgroundColor,
    Key? key
  }) : super(key: key);

  @override
  State<ResizableContainer> createState() => _ResizableContainerState();
}

class _ResizableContainerState extends State<ResizableContainer> {
  late double _currentHeight = widget.initialHeight + ResizableContainerConsts.toggleContainerHeight;
  double _startDragY = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: _currentHeight,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: SizedBox(
                height: ResizableContainerConsts.toggleContainerHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 1,
                      color: widget.toggleColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        width: ResizableContainerConsts.toggleWidth,
                        height: ResizableContainerConsts.toggleHeight,
                        decoration: BoxDecoration(
                          color: widget.toggleColor,
                          borderRadius: BorderRadius.circular(30)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: widget.child
          )
        ],
      ),
    );
  }

  _onPanStart(DragStartDetails details) {
    _startDragY = details.globalPosition.dy;
  }

  _onPanUpdate(DragUpdateDetails details) {
    final newValue = _currentHeight - (details.globalPosition.dy - _startDragY);

    setState(() {
      if(newValue < widget.minHeight + ResizableContainerConsts.toggleContainerHeight) {
        _currentHeight = widget.minHeight + ResizableContainerConsts.toggleContainerHeight;
      } else if(newValue > widget.maxHeight - ResizableContainerConsts.toggleContainerHeight) {
        _currentHeight = widget.maxHeight - ResizableContainerConsts.toggleContainerHeight;
      } else {
        _currentHeight = newValue;
      }
    });

    _startDragY = details.globalPosition.dy; 
  }
}
