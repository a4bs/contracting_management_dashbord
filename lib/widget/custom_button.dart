import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final bool isShow;
  final double? height;
  final double borderRadius;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isShow = true,
    this.width,
    this.height,
    this.borderRadius = 5,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return widget.isShow == false
        ? SizedBox.shrink()
        : Container(
            width: widget.width,
            height: widget.height ?? 50,
            constraints: BoxConstraints(minWidth: 56, minHeight: 32),
            child: ElevatedButton(
              onPressed: () async {
                if (isLoading) {
                  return;
                }
                setState(() {
                  isLoading = true;
                });
                await widget.onPressed();
                if (mounted) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: isLoading
                    ? Colors.grey
                    : (widget.backgroundColor ?? AppColors.lightPrimary),
                foregroundColor: widget.textColor ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: isLoading == true
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: 20),
                          SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.text,
                            style: TextStyle(
                              color: widget.textColor ?? Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
          );
  }
}
