import 'dart:ui';

import 'package:flutter/material.dart';

class NumpadPopupButton extends StatefulWidget {
  final Offset offset;

  const NumpadPopupButton({
    this.offset = Offset.zero,
    Key? key
  }) : super(key: key);

  @override
  State<NumpadPopupButton> createState() => _NumpadPopupButtonState();
}

class _NumpadPopupButtonState extends State<NumpadPopupButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Test"),
      onPressed: () {
        _showPopup();
      }, 
    );
  }

  Future<void> _showPopup({
    bool useRootNavigator = false,
  }) async {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + widget.offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final NavigatorState navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    await navigator.push(_NumpadPopupRoute(
      position: position,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
    ));
  }
}

class _NumpadPopup extends StatelessWidget {
  final double _borderRadiusValue = 20;

  final _NumpadPopupRoute route;

  const _NumpadPopup({
    required this.route
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: route.animation!,
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadiusValue),
          color: Colors.yellow,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container()
            ),
            _NumpadPopupButtonsRow(
              firstRow: true,
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: "1",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: "2",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: "3",
                  onPressed: () => {}
                )
              ],
            ),
            _NumpadPopupButtonsRow(
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: "4",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: "5",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: "6",
                  onPressed: () => {}
                )
              ],
            ),
            _NumpadPopupButtonsRow(
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: "7",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: "8",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: "9",
                  onPressed: () => {}
                )
              ],
            ),
            _NumpadPopupButtonsRow(
              lastRow: true,
              borderRadius: _borderRadiusValue,
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: "+/-",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: "0",
                  onPressed: () => {}
                ),
                _NumpadPopupButtonsData(
                  text: null,
                  onPressed: () => {}
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NumpadPopupButtonsData {
  final String? text;
  final void Function() onPressed;

  const _NumpadPopupButtonsData({
    required this.text,
    required this.onPressed
  });
}

class _NumpadPopupButtonsRow extends StatelessWidget{
  final bool firstRow;
  final bool lastRow;
  final double? borderRadius;
  final List<_NumpadPopupButtonsData> buttonsData;

  const _NumpadPopupButtonsRow({
    required this.buttonsData,
    this.firstRow = false,
    this.lastRow = false,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        buttonsData.length, 
        (index) {
          final buttonData = buttonsData[index];
          final borderRadiusAlignment = _calculateBorderRadiusAlignment(index);

          return _NumpadPopopButton(
            text: buttonData.text ?? "",
            onPressed: buttonData.onPressed,
            enabled: buttonData.text != null,
            showTopBorder: firstRow,
            showBottomBorder: lastRow == false,
            showRightBorder: (index == buttonsData.length - 1) == false,
            borderRadiusAlignment: borderRadiusAlignment,
            borderRadius: borderRadiusAlignment == null ? null : borderRadius,
          );
        }
      ),
    );
  }

  Alignment? _calculateBorderRadiusAlignment(int index) {
    if(lastRow) {
      if(index == 0) {
        return Alignment.bottomLeft;
      } else if(index == buttonsData.length - 1) {
        return Alignment.bottomRight;
      }
    }
    
    return null;
  }
}

class _NumpadPopopButton extends StatefulWidget {
  final String text;
  final void Function() onPressed;
  final bool enabled;
  final bool showTopBorder;
  final bool showRightBorder;
  final bool showBottomBorder;
  final Color borderColor;
  final double? borderRadius;
  final Alignment? borderRadiusAlignment;

  const _NumpadPopopButton({
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.showTopBorder = false,
    this.showRightBorder = true,
    this.showBottomBorder = true,
    this.borderColor = Colors.black,
    this.borderRadius,
    this.borderRadiusAlignment
  }) : assert(borderRadiusAlignment != null || borderRadius == null);

  @override
  State<_NumpadPopopButton> createState() => _NumpadPopopButtonState();
}

class _NumpadPopopButtonState extends State<_NumpadPopopButton> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTapDown:  widget.enabled ? (_) => setState(() => _isDown = true) : null,
        onTapCancel: widget.enabled ? () => setState(() => _isDown = false) : null,
        onTapUp: widget.enabled ? (_) => setState(() => _isDown = false) : null,
        onTap: widget.onPressed,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isDown ? const Color(0x44101010) : const Color(0x00000000),
                borderRadius: BorderRadius.only(
                  topLeft: (widget.borderRadiusAlignment == Alignment.topLeft) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                  topRight: (widget.borderRadiusAlignment == Alignment.topRight) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                  bottomRight: (widget.borderRadiusAlignment == Alignment.bottomRight) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                  bottomLeft: (widget.borderRadiusAlignment == Alignment.bottomLeft) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                ),
              ),
              child: Text(widget.text),
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: widget.showTopBorder ? BorderSide(color: widget.borderColor, width: 2) : BorderSide.none,
                  right: widget.showRightBorder ? BorderSide(color: widget.borderColor, width: 2) : BorderSide.none,
                  bottom: widget.showBottomBorder ? BorderSide(color: widget.borderColor, width: 2) : BorderSide.none
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class _NumpadPopupRoute<T> extends PopupRoute<T> {
  final RelativeRect position;
  final CapturedThemes capturedThemes;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  _NumpadPopupRoute({
    required this.position,
    required this.barrierLabel,
    required this.capturedThemes,
  });

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeOut
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _NumpadPopupRouteLayout(
              position,
              Directionality.of(context),
              mediaQuery.padding,
            ),
            child: capturedThemes.wrap(_NumpadPopup(route: this)),
          );
        },
      ),
    );
  }
}


class _NumpadPopupRouteLayout extends SingleChildLayoutDelegate {
  final double _kMenuScreenPadding = 30;
  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // Whether to prefer going to the left or to the right.
  final TextDirection textDirection;

  // The padding of unsafe area.
  final EdgeInsets padding;

  _NumpadPopupRouteLayout(
    this.position,
    this.textDirection,
    this.padding,
  );

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Find the ideal horizontal position.
    double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    } else {
      // Menu button is equidistant from both edges, so grow in reading direction.
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }

    // Avoid going outside an area defined as the rectangle 8.0 pixels from the
    // edge of the screen in every direction.
    double y = position.top;
    if (x < _kMenuScreenPadding + padding.left) {
      x = _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width > size.width - _kMenuScreenPadding - padding.right) {
      x = size.width - childSize.width - _kMenuScreenPadding - padding.right  ;
    }
    if (y < _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height > size.height - _kMenuScreenPadding - padding.bottom) {
      y = size.height - padding.bottom - _kMenuScreenPadding - childSize.height ;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_NumpadPopupRouteLayout oldDelegate) {
    return position != oldDelegate.position || textDirection != oldDelegate.textDirection || padding != oldDelegate.padding;
  }
}
