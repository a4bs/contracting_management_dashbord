import 'dart:io';
import 'dart:async';
import 'package:contracting_management_dashbord/constant/app_route.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:contracting_management_dashbord/services/local_storge.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HandleError {
  static void processError(
    dynamic error,
    String source, {
    String? customMessage,
  }) {}

  static String handleError(dynamic error) {
    processError(error, 'handleError');

    String errorMessage = "";

    if (error == null) {
      return "حدث خطأ غير معروف";
    }

    if (error is DioException) {
      errorMessage = handleDioError(error);
    } else if (error is SocketException) {
      errorMessage = _handleSocketException(error);
    } else if (error is HttpException) {
      errorMessage = _handleHttpException(error);
    } else if (error is WebSocketException) {
      errorMessage = "خطأ في اتصال WebSocket";
    } else if (error is TimeoutException) {
      errorMessage = "انتهت مهلة العملية";
    } else if (error is PlatformException) {
      errorMessage = _handlePlatformException(error);
    } else if (error is FormatException) {
      errorMessage = "خطأ في تنسيق البيانات";
    } else if (error is TypeError) {
      final String typeErrorMessage = error.toString();
      if (typeErrorMessage.contains('null')) {
        errorMessage = "محاولة الوصول إلى قيمة فارغة";
      } else {
        errorMessage = "خطأ في نوع البيانات: ${error.toString()}";
      }
    } else if (error is StateError) {
      errorMessage = "خطأ في حالة التطبيق";
    } else if (error is AssertionError) {
      errorMessage = "خطأ في التحقق من الشروط";
    } else if (error is NoSuchMethodError) {
      errorMessage = "محاولة استدعاء دالة غير موجودة";
    } else if (error is UnsupportedError) {
      errorMessage = "عملية غير مدعومة";
    } else if (error is RangeError) {
      errorMessage = "خطأ في نطاق القيم";
    } else if (error is ArgumentError) {
      errorMessage = "خطأ في المعاملات المدخلة";
    } else if (error is ConcurrentModificationError) {
      errorMessage = "خطأ في التعديل المتزامن";
    } else if (error is OutOfMemoryError) {
      errorMessage = "نفاد الذاكرة";
    } else if (error is StackOverflowError) {
      errorMessage = "تجاوز حد المكدس";
    } else if (error is String) {
      errorMessage = error;
    } else {
      errorMessage = error.toString();
    }

    _logError(error, errorMessage);
    return errorMessage;
  }

  static String handleDioError(DioException error) {
    processError(error, '_handleDioError');
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "انتهت مهلة الاتصال بالخادم";
      case DioExceptionType.sendTimeout:
        return "انتهت مهلة إرسال البيانات";
      case DioExceptionType.receiveTimeout:
        return "انتهت مهلة استلام البيانات";
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            CustomToast.showError(
              title: 'خطأ في الطلب',
              description: '${error.response?.data['data']['message']}',
            );

            return "طلب غير صالح";
          case 422:
            if (error.response?.data['data'] != null) {
              CustomToast.showError(
                title: 'خطأ في البيانات',
                description: '${error.response?.data['data']['message']}',
              );
            } else {
              CustomToast.showError(
                title: 'خطأ في البيانات',
                description: '${error.response?.data['message']}',
              );
            }

            return "طلب غير صالح";
          case 401:
            LocalStorageService.clearAll();
            if (Get.currentRoute != AppRoute.login) {
              Get.offAndToNamed(AppRoute.login);
            }
            return "غير مصرح لك بالوصول";
          case 403:
            return "الوصول محظور";
          case 404:
            return "المورد غير موجود";
          case 500:
            return "خطأ في الخادم";
          default:
            return "حدث خطأ غير متوقع";
        }
      case DioExceptionType.cancel:
        return "تم إلغاء الطلب";
      case DioExceptionType.connectionError:
        return "فشل الاتصال بالإنترنت";
      default:
        return "حدث خطأ غير متوقع";
    }
  }

  static String _handleSocketException(SocketException error) {
    processError(error, '_handleSocketException');
    switch (error.osError?.errorCode) {
      case 7:
        return "لا يمكن الوصول إلى الخادم";
      case 101:
        return "الشبكة غير متاحة";
      case 111:
        return "تم رفض الاتصال";

      default:
        return "تحقق من اتصال الإنترنت";
    }
  }

  static String _handleHttpException(HttpException error) {
    if (error.message.contains('Failed host lookup')) {
      return "فشل في العثور على الخادم";
    } else if (error.message.contains('Connection refused')) {
      return "تم رفض الاتصال بالخادم";
    }
    return "خطأ في اتصال HTTP: ${error.message}";
  }

  static String _handlePlatformException(PlatformException error) {
    processError(error, '_handlePlatformException');
    switch (error.code) {
      case 'PERMISSION_DENIED':
        return "تم رفض الإذن المطلوب";
      case 'CAMERA_ACCESS_DENIED':
        return "تم رفض الوصول إلى الكاميرا";
      case 'LOCATION_SERVICES_DISABLED':
        return "خدمات الموقع معطلة";
      default:
        return error.message ?? "حدث خطأ في النظام";
    }
  }

  static void _logError(dynamic error, String errorMessage) {
    // final DateTime timestamp = DateTime.now();
    // final String stackTrace = StackTrace.current.toString();
  }

  static void showErrorSnackbar(dynamic error) {
    if (error is Map && error.containsKey('message')) {
      CustomToast.showError(
        title: 'خطأ',
        description: error['message'].toString(),
      );
    } else {
      final errorMessage = handleError(error);
      CustomToast.showError(title: 'خطأ', description: errorMessage);
    }
  }

  static void handleErrorByScreen(dynamic error, String screenName) {
    final errorMessage = handleError(error);

    switch (screenName) {
      case 'login':
        CustomToast.showError(
          title: 'خطأ بتسجيل الدخول',
          description:
              error.response?.data['message']?.toString() ?? errorMessage,
        );
        break;
      case 'profile':
        CustomToast.showError(
          title: 'خطأ في الملف الشخصي',
          description:
              error.response?.data['message']?.toString() ?? errorMessage,
        );
        break;
      default:
        showErrorSnackbar(error);
    }
  }

  static Future<bool> checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<T?> retryOperation<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts == maxAttempts) {
          showErrorSnackbar(e);
          return null;
        }
        await Future.delayed(delay);
      }
    }
    return null;
  }

  static Future<void> handleAuthenticationError(dynamic error) async {
    if (error is DioException && error.response?.statusCode == 401) {
      // محاولة تحديث التوكن
      try {
        await _refreshToken();
      } catch (e) {
        // إذا فشل تحديث التوكن، قم بتسجيل الخروج
        await _handleLogout();
      }
    }
  }

  static Future<void> _refreshToken() async {
    // تنفيذ منطق تحديث التوكن
  }

  static Future<void> _handleLogout() async {
    // try {
    //   final authController = Get.find<HomeController>();
    //   if (Get.context != null) {
    //     await authController.logout();
    //   }
    // } catch (e) {
    //   processError(e, '_handleLogout');
    // }
  }

  static Future<bool> isNetworkAvailable() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup(
        'google.com',
      );
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<T?> retryOnError<T>({
    required Future<T> Function() operation,
    int maxAttempts = 3,
    Duration delay = const Duration(seconds: 2),
    bool Function(dynamic)? retryIf,
  }) async {
    int attempts = 0;
    dynamic lastError;

    while (attempts < maxAttempts) {
      try {
        return await operation();
      } catch (e) {
        lastError = e;
        attempts++;

        if (retryIf != null && !retryIf(e)) {
          break;
        }

        if (attempts == maxAttempts) {
          break;
        }

        await Future.delayed(delay * attempts);
      }
    }

    showErrorSnackbar(lastError);
    return null;
  }

  static void handleFormError(dynamic error, BuildContext context) {
    if (error is Map<String, dynamic>) {
      // معالجة أخطاء التحقق من صحة النموذج
      final validationErrors = error['errors'] as Map<String, dynamic>?;
      if (validationErrors != null) {
        String errorMessage = validationErrors.values.join('\n');
        showErrorSnackbar(errorMessage);
      }
    } else {
      showErrorSnackbar(error);
    }
  }

  static bool isValidResponse(dynamic response) {
    if (response == null) return false;
    if (response is Map) return true;
    if (response is List) return true;
    return false;
  }
}
