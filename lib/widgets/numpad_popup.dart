import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class NumpadPopupButton extends StatefulWidget {
  const NumpadPopupButton({
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
    double initialValue = 0
  }) async {
    final button = context.findRenderObject()! as RenderBox;
    final offset = Offset(0, button.size.height + 10);
    final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    await navigator.push(_NumpadPopupRoute(
      position: position,
      initialValue: initialValue,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
    ));
  }
}

class _NumpadPopup extends StatefulWidget {
  final double initialValue;
  final _NumpadPopupRoute route;

  const _NumpadPopup({
    required this.route,
    required this.initialValue
  });

  @override
  State<_NumpadPopup> createState() => _NumpadPopupState();
}

class _NumpadPopupState extends State<_NumpadPopup> {
  final double _borderRadiusValue = 20;
  late final ValueNotifier<String> _currentValue;

  @override
  void initState() {
    String tempCurrentValue = widget.initialValue.toString();
    final last = tempCurrentValue.split(".").last;
    if(last == "0") {
      tempCurrentValue.replaceAll(last, "");
    }
    _currentValue = ValueNotifier(tempCurrentValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.route.animation!,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<String>(
                        valueListenable: _currentValue,
                        builder: (context, currentValue, child) {
                          return AutoSizeText(
                            currentValue,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 40
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ),
            _NumpadPopupButtonsRow(
              firstRow: true,
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: "1",
                  onPressed: () => setState(() {
                    _currentValue.value += "1";
                  })
                ),
                _NumpadPopupButtonsData(
                  text: "2",
                  onPressed: () => setState(() {
                    _currentValue.value += "2";
                  })
                ),
                _NumpadPopupButtonsData(
                  text: "3",
                  onPressed: () => setState(() {
                    _currentValue.value += "3";
                  })
                )
              ],
            ),
            _NumpadPopupButtonsRow(
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: "4",
                  onPressed: () => setState(() {
                    _currentValue.value += "4";
                  })
                ),
                _NumpadPopupButtonsData(
                  text: "5",
                  onPressed: () => setState(() {
                    _currentValue.value += "5";
                  })
                ),
                _NumpadPopupButtonsData(
                  text: "6",
                  onPressed: () => setState(() {
                    _currentValue.value += "6";
                  })
                )
              ],
            ),
            _NumpadPopupButtonsRow(
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: "7",
                  onPressed: () => setState(() {
                    _currentValue.value += "7";
                  })
                ),
                _NumpadPopupButtonsData(
                  text: "8",
                  onPressed: () => setState(() {
                    _currentValue.value += "8";
                  })
                ),
                _NumpadPopupButtonsData(
                  text: "9",
                  onPressed: () => setState(() {
                    _currentValue.value += "9";
                  })
                )
              ],
            ),
            _NumpadPopupButtonsRow(
              lastRow: true,
              borderRadius: _borderRadiusValue,
              buttonsData: [
                _NumpadPopupButtonsData(
                  text: ".",
                  onPressed: () {
                    if(_currentValue.value.contains(".") == false) {
                      setState(() {
                        _currentValue.value += ".";
                      });
                    }
                  }
                ),
                _NumpadPopupButtonsData(
                  text: "0",
                  onPressed: () => setState(() {
                    _currentValue.value += "0";
                  })
                ),
                _NumpadPopupButtonsData(
                  child: const Icon(
                    Icons.backspace_rounded
                  ),
                  onPressed: () {
                    if(_currentValue.value.isNotEmpty) {
                       setState(() {
                        _currentValue.value = _currentValue.value.substring(0, _currentValue.value.length - 1);
                      });
                    }
                  }
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
  final Widget? child;
  final void Function() onPressed;

  const _NumpadPopupButtonsData({
    this.text,
    this.child,
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
            text: buttonData.text,
            child: buttonData.child,
            onPressed: buttonData.onPressed,
            enabled: buttonData.text != null || buttonData.child != null,
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
  final String? text;
  final Widget? child;
  final void Function() onPressed;
  final bool enabled;
  final bool showTopBorder;
  final bool showRightBorder;
  final bool showBottomBorder;
  final Color borderColor;
  final double? borderRadius;
  final Alignment? borderRadiusAlignment;

  const _NumpadPopopButton({
    required this.onPressed,
    this.text,
    this.child,
    this.enabled = true,
    this.showTopBorder = false,
    this.showRightBorder = true,
    this.showBottomBorder = true,
    this.borderColor = Colors.black,
    this.borderRadius,
    this.borderRadiusAlignment
  }) : assert((borderRadiusAlignment != null || borderRadius == null) && (text == null || child == null));

  @override
  State<_NumpadPopopButton> createState() => _NumpadPopopButtonState();
}

class _NumpadPopopButtonState extends State<_NumpadPopopButton> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: MouseRegion(
        cursor: (widget.enabled) ? SystemMouseCursors.click : SystemMouseCursors.alias,
        child: GestureDetector(
          onTapDown:  widget.enabled ? (_) => setState(() => _isDown = true) : null,
          onTapCancel: widget.enabled ? () => setState(() => _isDown = false) : null,
          onTapUp: widget.enabled ? (_) => setState(() => _isDown = false) : null,
          onTap: widget.onPressed,
          child: Stack(
            children: [
              RepaintBoundary(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isDown && widget.text != null ? const Color(0x44101010) : const Color(0x00000000),
                    borderRadius: BorderRadius.only(
                      topLeft: (widget.borderRadiusAlignment == Alignment.topLeft) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                      topRight: (widget.borderRadiusAlignment == Alignment.topRight) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                      bottomRight: (widget.borderRadiusAlignment == Alignment.bottomRight) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                      bottomLeft: (widget.borderRadiusAlignment == Alignment.bottomLeft) ? Radius.circular(widget.borderRadius!) : Radius.zero,
                    ),
                  ),
                  child: (widget.text != null) 
                    ? Text(widget.text!) 
                    : AnimatedScale(
                      scale: _isDown && widget.child != null ? 0.9 : 1, 
                      duration: const Duration(milliseconds: 100),
                      child: widget.child,
                    ),
                ),
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
        ),
      )
    );
  }
}

class _NumpadPopupRoute<T> extends PopupRoute<T> {
  final RelativeRect position;
  final CapturedThemes capturedThemes;
  final double initialValue;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

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
    required this.initialValue
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
            child: capturedThemes.wrap(_NumpadPopup(
              route: this,
              initialValue: initialValue,
            )),
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
