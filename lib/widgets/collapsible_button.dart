import 'package:flutter/material.dart';

class CollapsibleButton extends StatelessWidget {
  final Color color, iconColor;
  final IconData icon;
  final void Function()? onPress;

  const CollapsibleButton({
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 50,
        width: 50,
        color: color,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      onTap: onPress,
    );
  }
}
