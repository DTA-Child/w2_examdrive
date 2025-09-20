import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final IconData? icon;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height ?? 48,
        child: OutlinedButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: _buildIcon(),
          label: _buildLabel(),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: backgroundColor ?? Colors.blue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: _buildIcon(),
        label: _buildLabel(),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.blue,
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Icon(icon);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLabel() {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isOutlined ? (backgroundColor ?? Colors.blue) : (textColor ?? Colors.white),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String option;
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool showResult;
  final VoidCallback? onPressed;

  const AnswerButton({
    super.key,
    required this.option,
    required this.text,
    this.isSelected = false,
    this.isCorrect = false,
    this.isWrong = false,
    this.showResult = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black87;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = Colors.green[50]!;
        borderColor = Colors.green;
        textColor = Colors.green[800]!;
      } else if (isWrong) {
        backgroundColor = Colors.red[50]!;
        borderColor = Colors.red;
        textColor = Colors.red[800]!;
      }
    } else if (isSelected) {
      backgroundColor = Colors.blue[50]!;
      borderColor = Colors.blue;
      textColor = Colors.blue[800]!;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: showResult ? null : onPressed,
        borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: borderColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (showResult && isCorrect)
                Icon(Icons.check_circle, color: Colors.green, size: 24),
              if (showResult && isWrong)
                Icon(Icons.cancel, color: Colors.red, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}