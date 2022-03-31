import 'package:flutter/cupertino.dart';

class ConditionalWrapper extends StatelessWidget {
  final bool condition;
  final Function(BuildContext context, Widget child) wrapperBuilder;
  final Widget child;

  const ConditionalWrapper({
    required this.condition,
    required this.wrapperBuilder,
    required this.child,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(condition) {
      return wrapperBuilder(context, child);
    }

    return child;
  }
}
