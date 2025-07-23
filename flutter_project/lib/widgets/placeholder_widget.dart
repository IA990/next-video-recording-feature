import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
  final String message;
  final double? fontSize;
  final Color? color;
  final IconData? icon;

  const PlaceholderWidget({
    Key? key,
    required this.message,
    this.fontSize,
    this.color,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? Colors.grey;
    final defaultFontSize = fontSize ?? 18.0;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: defaultFontSize * 2,
              color: defaultColor,
            ),
          if (icon != null) const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              fontSize: defaultFontSize,
              fontStyle: FontStyle.italic,
              color: defaultColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
