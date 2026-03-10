import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  static void showSuccess({
    required String title,
    String? description,
    Duration autoCloseDuration = const Duration(seconds: 1),
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: autoCloseDuration,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            )
          : null,
      alignment: Alignment.topRight,
      direction: TextDirection.rtl,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check_circle_outline),
      showIcon: true,
      primaryColor: Colors.white,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.white,
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  static void showError({
    required String title,
    String? description,
    Duration autoCloseDuration = const Duration(seconds: 5),
  }) {
    toastification.show(
      backgroundColor: Colors.red,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: autoCloseDuration,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            )
          : null,
      alignment: Alignment.topRight,
      direction: TextDirection.rtl,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.error_outline),
      showIcon: true,
      primaryColor: Colors.white,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  static void showWarning({
    required String title,
    String? description,
    Duration autoCloseDuration = const Duration(seconds: 5),
  }) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      autoCloseDuration: autoCloseDuration,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            )
          : null,
      alignment: Alignment.topRight,
      direction: TextDirection.rtl,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.warning_amber_rounded),
      showIcon: true,
      primaryColor: Colors.white,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }

  static void showInfo({
    required String title,
    String? description,
    Duration autoCloseDuration = const Duration(seconds: 4),
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: autoCloseDuration,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      description: description != null
          ? Text(
              description,
              style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            )
          : null,
      alignment: Alignment.topRight,
      direction: TextDirection.rtl,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.info_outline),
      showIcon: true,
      primaryColor: Colors.white,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeButton: const ToastCloseButton(
        showType: CloseButtonShowType.onHover,
      ),
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }
}
