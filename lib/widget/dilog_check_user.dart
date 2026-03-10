import 'package:contracting_management_dashbord/theme/app_colors.dart';
import 'package:contracting_management_dashbord/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showConfirmationDialog({
  required String title,
  required String message,
  required Future<void> Function() onConfirm,
  VoidCallback? onCancel,
  String confirmText = 'نعم',
  String cancelText = 'إلغاء',
}) async {
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: confirmText,
                onPressed: () async {
                  await onConfirm();
                  Get.back();
                },
                backgroundColor: AppColors.lightPrimary,
                textColor: Colors.white,
                borderRadius: 8,
                height: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: cancelText,
                onPressed: () async {
                  Get.back();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
                backgroundColor: Colors.grey[200],
                textColor: Colors.black87,
                borderRadius: 8,
                height: 40,
              ),
            ),
          ],
        ),
      ],
    ),
    barrierDismissible: false,
  );
}