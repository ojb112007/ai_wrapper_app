// Custom auth button widget
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? icon;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const AuthButton({
    required this.onPressed,
    required this.text,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1)
                : BorderSide.none,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment:
              icon != null ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              SizedBox(width: 36, child: Center(child: icon)),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
            if (icon != null) const SizedBox(width: 36),
          ],
        ),
      ),
    );
  }
}