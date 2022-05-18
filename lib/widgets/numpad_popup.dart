import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turtle_game/extras/extensions.dart';
import 'package:turtle_game/widgets/button_icon.dart';

class NumpadPopupButton extends StatefulWidget {
  final bool disableComma;
  final Function(BuildContext context, Future<double?> Function(double initialValue, { bool showFullScreen }) showPopup) builder;

  const NumpadPopupButton({
    required this.builder,
    this.disableComma = false,
    Key? key
  }) : super(key: key);

  @override
  State<NumpadPopupButton> createState() => _NumpadPopupButtonState();
}

class _NumpadPopupButtonState extends State<NumpadPopupButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: widget.builder(context, _showPopup),
    );
  }

  Future<double?> _showPopup(double initialValue, { bool showFullScreen = false }) async {
    final button = context.findRenderObject()! as RenderBox;
    const offset = Offset(0, 0);
    final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final navigator = Navigator.of(context, rootNavigator: false);
    return await navigator.push(_NumpadPopupRoute(
      position: position,
      initialValue: initialValue,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      parentSize: button.size,
      showFullScreen: showFullScreen,
      disableComma: widget.disableComma
    ));
  }
}


class _NumpadPopup extends StatefulWidget {
  final _NumpadPopupRoute route;
  final bool showFullScreen;
  final bool disableComma;
  final double initialValue;

  const _NumpadPopup({
    required this.route,
    required this.showFullScreen,
    required this.disableComma,
    required this.initialValue
  });

  @override
  State<_NumpadPopup> createState() => _NumpadPopupState();
}

class _NumpadPopupState extends State<_NumpadPopup> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  final double _borderRadiusValue = 20;

  @override
  void initState() {
    _textEditingController.text = widget.initialValue.toStringWihtoutTrailingZeros();
    
    if(PlatformExtenstion.isTouchDevice() == false) {
      _focusNode.requestFocus();
    }
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    final theme = Theme.of(context);
    final isTouchDevice = PlatformExtenstion.isTouchDevice();

    return ScaleTransition(
      scale: widget.route.animation!,
      child: Container(
        width: widget.showFullScreen ? null : 200,
        height: widget.showFullScreen ? null : (isTouchDevice) ? 300 : 100,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadiusValue),
          border: Border.all(color: theme.dividerTheme.color!, width: theme.dividerTheme.thickness!),
          color: Colors.yellow,
          boxShadow: const [
            BoxShadow(
              spreadRadius: 0,
              color: Color(0xAA000000),
              offset: Offset(2, 2),
              blurRadius: 1
            )
          ]
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: EditableText(
                        controller: _textEditingController,
                        cursorColor: theme.textSelectionTheme.cursorColor!,
                        focusNode: _focusNode,
                        backgroundCursorColor: Colors.green,
                        maxLines: 1, 
                        style: theme.textTheme.bodyText2!.copyWith(
                          fontSize: 40
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(',', replacementString: '.'),
                          FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})')),
                        ],
                        onSubmitted: (_) => _onConfirm(),                    
                      )
                    ),
                    Visibility(
                      visible: isTouchDevice && _textEditingController.text.isNotEmpty,
                      child: ButtonIcon(
                        icon: const Icon(Icons.backspace_rounded), 
                        onPressed: () {
                          if(_textEditingController.text.isNotEmpty) {
                            _textEditingController.text = _textEditingController.text.substring(0, _textEditingController.text.length - 1);
                          }
                        }
                      ),
                    )
                  ],
                )
              )
            ),
            if(isTouchDevice)
              _NumpadPopupButtonsRow(
                firstRow: true,
                buttonsData: [
                  _NumpadPopupButtonsData(
                    text: "1",
                    onPressed: () => _textEditingController.text += "1"
                  ),
                  _NumpadPopupButtonsData(
                    text: "2",
                    onPressed: () => _textEditingController.text += "2"
                  ),
                  _NumpadPopupButtonsData(
                    text: "3",
                    onPressed: () => _textEditingController.text += "3"
                  )
                ],
              ),
            if(isTouchDevice)
              _NumpadPopupButtonsRow(
                buttonsData: [
                  _NumpadPopupButtonsData(
                    text: "4",
                    onPressed: () => _textEditingController.text += "4"
                  ),
                  _NumpadPopupButtonsData(
                    text: "5",
                    onPressed: () => _textEditingController.text += "5"
                  ),
                  _NumpadPopupButtonsData(
                    text: "6",
                    onPressed: () => _textEditingController.text += "6"
                  )
                ],
              ),
            if(isTouchDevice)
              _NumpadPopupButtonsRow(
                buttonsData: [
                  _NumpadPopupButtonsData(
                    text: "7",
                    onPressed: () => _textEditingController.text += "7"
                  ),
                  _NumpadPopupButtonsData(
                    text: "8",
                    onPressed: () => _textEditingController.text += "8"
                  ),
                  _NumpadPopupButtonsData(
                    text: "9",
                    onPressed: () => _textEditingController.text += "9"
                  )
                ],
              ),
            if(isTouchDevice)
              _NumpadPopupButtonsRow(
                buttonsData: [
                  if(widget.disableComma)
                    const _NumpadPopupButtonsData(),
                  if(widget.disableComma == false)
                    _NumpadPopupButtonsData(
                      text: ".",
                      onPressed: () {
                        if(_textEditingController.text.contains(".") == false) {
                          _textEditingController.text += ".";
                        }
                      }
                    ),
                  _NumpadPopupButtonsData(
                    text: "0",
                    onPressed: () => _textEditingController.text += "0"
                  ),
                  _NumpadPopupButtonsData(
                    text: "+/-",
                    onPressed: () {
                      final currentSign = _textEditingController.text[0];

                      switch(currentSign) {                    
                        case "-":
                          _textEditingController.text = "+" + _textEditingController.text.substring(1);
                          break;
                        case "+":
                          _textEditingController.text = "-" + _textEditingController.text.substring(1);
                          break;
                        default:
                          _textEditingController.text = "-" + _textEditingController.text;
                      }
                    }
                  )
                ],
              ),
            _NumpadPopupButtonsRow(
              lastRow: true,
              firstRow: isTouchDevice == false,
              borderRadius: _borderRadiusValue,
              buttonsData: [
                _NumpadPopupButtonsData(
                  child: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop()
                ),
                const _NumpadPopupButtonsData(),
                _NumpadPopupButtonsData(
                  child: const Icon(Icons.check_rounded),
                  onPressed: _onConfirm
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onConfirm() {
    final newValue = double.tryParse(_textEditingController.text);
    Navigator.of(context).pop(newValue);
  }
}

class _NumpadPopupButtonsData {
  final String? text;
  final Widget? child;
  final void Function()? onPressed;

  const _NumpadPopupButtonsData({
    this.text,
    this.child,
    this.onPressed
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

          return _NumpadPopopButton(
            text: buttonData.text,
            child: buttonData.child,
            onPressed: buttonData.onPressed,
            showTopBorder: firstRow,
            showBottomBorder: lastRow == false,
            showRightBorder: (index == buttonsData.length - 1) == false,
          );
        }
      ),
    );
  }
}

class _NumpadPopopButton extends StatefulWidget {
  final String? text;
  final Widget? child;
  final void Function()? onPressed;
  final bool showTopBorder;
  final bool showRightBorder;
  final bool showBottomBorder;

  const _NumpadPopopButton({
    this.text,
    this.child,
    this.onPressed,
    this.showTopBorder = false,
    this.showRightBorder = true,
    this.showBottomBorder = true,
  }) : assert(text == null || child == null);

  @override
  State<_NumpadPopopButton> createState() => _NumpadPopopButtonState();
}

class _NumpadPopopButtonState extends State<_NumpadPopopButton> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = widget.onPressed != null;

    return Flexible(
      child: MouseRegion(
        cursor: (enabled) ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTapDown:  enabled ? (_) => setState(() => _isDown = true) : null,
          onTapCancel: enabled ? () => setState(() => _isDown = false) : null,
          onTapUp: enabled ? (_) => setState(() => _isDown = false) : null,
          onTap: widget.onPressed,
          child: RepaintBoundary(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isDown && widget.text != null ? const Color(0x44101010) : const Color(0x00000000),
                border: Border(
                  top: widget.showTopBorder ? BorderSide(color: theme.dividerTheme.color!, width: theme.dividerTheme.thickness!) : BorderSide.none,
                  right: widget.showRightBorder ? BorderSide(color: theme.dividerTheme.color!, width: theme.dividerTheme.thickness!) : BorderSide.none,
                  bottom: widget.showBottomBorder ? BorderSide(color: theme.dividerTheme.color!, width: theme.dividerTheme.thickness!) : BorderSide.none
                ),
              ),
              child: _getChild()
            ),
          ),
        ),
      )
    );
  }

  Widget _getChild() {
    if(widget.text != null) {
      return Text(widget.text!);
    } else if(widget.child != null) {
      return AnimatedScale(
        scale: _isDown && widget.child != null ? 0.9 : 1, 
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _NumpadPopupRoute<T> extends PopupRoute<T> {
  final RelativeRect position;
  final CapturedThemes capturedThemes;
  final double initialValue;
  final Size parentSize;
  final bool showFullScreen;
  final bool disableComma;

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
    required this.initialValue,
    required this.parentSize,
    required this.showFullScreen,
    required this.disableComma
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
              parentSize,
              showFullScreen
            ),
            child: capturedThemes.wrap(_NumpadPopup(
              route: this,
              initialValue: initialValue,
              showFullScreen: showFullScreen,
              disableComma: disableComma,
            )),
          );
        },
      ),
    );
  }
}


class _NumpadPopupRouteLayout extends SingleChildLayoutDelegate {
  final double _globalChildPadding = 15;
  final double _toggleSpace = 10;
  
  final RelativeRect position;
  final TextDirection textDirection;
  final EdgeInsets padding;
  final Size parentSize;
  final bool showFullScreen;

  _NumpadPopupRouteLayout(
    this.position,
    this.textDirection,
    this.padding,
    this.parentSize,
    this.showFullScreen
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest).deflate(
      EdgeInsets.all(_globalChildPadding) + padding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    if(showFullScreen) {
      return Offset(_globalChildPadding, _globalChildPadding);
    }

    double x;
    if (position.left > position.right) {
      x = size.width - position.right - childSize.width;
    } else {
      x = position.left + parentSize.width + _toggleSpace;
    }

    double y = position.top + (parentSize.height + _toggleSpace);
    if (x < _globalChildPadding + padding.left) {
      x = _globalChildPadding + padding.left;
    } else if (x + childSize.width > size.width - _globalChildPadding - padding.right) {
      x = size.width - childSize.width - _globalChildPadding - padding.right;
    }
    if (y < _globalChildPadding + padding.top) {
      y = _globalChildPadding + padding.top;
      x += (parentSize.width + _toggleSpace);
    } else if (y + childSize.height > size.height - _globalChildPadding - padding.bottom) {
      y = size.height - padding.bottom - _globalChildPadding - childSize.height;
      if(position.left > position.right) {
        x -= (parentSize.width + _toggleSpace);
      }
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_NumpadPopupRouteLayout oldDelegate) {
    return position != oldDelegate.position || textDirection != oldDelegate.textDirection || padding != oldDelegate.padding;
  }
}
