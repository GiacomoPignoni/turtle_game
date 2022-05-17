import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turtle_game/models/command.dart';
import 'package:turtle_game/states/commands_state.dart';
import 'package:turtle_game/widgets/conditional_wrapper.dart';

class MainScreenCommandTile extends StatelessWidget {
  final Command command;
  final int index;

  const MainScreenCommandTile({
    Key? key,
    required this.command,
    required this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: CommandTileBody(
        command: command,
        showTrash: true,
        hideTopCurve: index == 0,
        onTapDelete: () => Provider.of<CommandsState>(context, listen: false).remove(index),
      )
    );
  }
}

class CommandTileBody extends StatelessWidget {
  final Command command;
  final bool showTrash;
  final Function()? onTapDelete;
  final bool hideTopCurve;

  const CommandTileBody({
    Key? key,
    required this.command,
    this.hideTopCurve = false,
    this.showTrash = false,
    this.onTapDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: command,
      builder: (context, child) {
        return ConditionalWrapper(
          condition: showTrash,
          wrapperBuilder: (context, child) {
            return Stack(
              children: [
                child,
                Positioned(
                  top: 0,
                  right: 0,
                  child: CommandTileBodyDeleteIcon(
                    onPressed: onTapDelete,
                  )
                )
              ],
            );
          },
          child: SizedBox(
            width: 300,
            height: 50,
            child: CustomPaint(
              painter: CommandTileBodyCustomPainter(
                borderRadius: 10,
                curveMarginPercentage: 0.25,
                color: command.getColor(),
                borderColor: theme.dividerTheme.color!.withOpacity(0.5),
                hideTopCurve: hideTopCurve
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        command.toString(),
                        style: theme.textTheme.bodyText1,
                      )
                    ),
                    Expanded(
                      child: Text(
                        command.getValueToShow(),
                        style: theme.textTheme.bodyText1,
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

class CommandTileBodyDeleteIcon extends StatefulWidget {
  final Function()? onPressed;

  const CommandTileBodyDeleteIcon({
    required this.onPressed,
    Key? key
  }): super(key: key);

  @override
  State<CommandTileBodyDeleteIcon> createState() => _CommandTileBodyDeleteIconState();
}

class _CommandTileBodyDeleteIconState extends State<CommandTileBodyDeleteIcon> {
  bool _isHover = false;
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) => setState(() {_isHover = true;}),
      onExit: (_) => setState(() {_isHover = false;}),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _isDown = true),
        onTapUp: (details) => setState(() => _isDown = false),
        onTapCancel: () => setState(() => _isDown = false),
        child: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: (_isHover) ? theme.primaryColorDark.withOpacity(0.8) : theme.primaryColorDark,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)
            )
          ),
          child: AnimatedScale(
            scale: _isDown ? 0.9 : 1,
            duration: const Duration(milliseconds: 100),
            child: Icon(
              Icons.close_rounded,
              color: theme.primaryColorLight, 
              size: 14
            ),
          ),
        ),
      ),
    );
  }
}

class CommandTileBodyCustomPainter extends CustomPainter {
  final double borderRadius;
  final double curveMarginPercentage;
  final Color color;
  final Color borderColor;
  final bool hideTopCurve;

  CommandTileBodyCustomPainter({
    required this.borderRadius,
    required this.curveMarginPercentage,
    required this.color,
    required this.borderColor,
    required this.hideTopCurve
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final curveMargin = size.width * curveMarginPercentage;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 1
      ..isAntiAlias = true;

    final path = Path();
    path.fillType = PathFillType.evenOdd;

    path.moveTo(0, borderRadius);
    path.quadraticBezierTo(0, 0, borderRadius, 0);

    if(hideTopCurve) {
      path.lineTo(size.width - curveMargin, 0);
    } else {
      path.lineTo(curveMargin, 0);
      path.quadraticBezierTo(size.width / 2, 20, size.width - curveMargin, 0);
    }

    path.lineTo(size.width - borderRadius, 0);   
    path.quadraticBezierTo(size.width, 0, size.width, borderRadius);

    path.lineTo(size.width, size.height - borderRadius);
    path.quadraticBezierTo(size.width, size.height, size.width - borderRadius, size.height);

    path.lineTo(size.width - curveMargin, size.height);
    path.quadraticBezierTo(size.width / 2, size.height + 20, curveMargin, size.height);

    path.lineTo(borderRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - borderRadius);
    
    path.lineTo(0, borderRadius);   

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
