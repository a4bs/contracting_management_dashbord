import 'dart:io';
import 'package:contracting_management_dashbord/constant/app_key.dart';
import 'package:contracting_management_dashbord/services/connection_service.dart';
import 'package:contracting_management_dashbord/services/handel_error.dart';
import 'package:contracting_management_dashbord/tool/user_tool.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:path_provider/path_provider.dart';

// For path manipulation
class DioNetwork {
  Directory? cacheDir;
  static var apiUrl = AppKeys.apiUrl;
  static ConnectionService get connectionService =>
      getx.Get.find<ConnectionService>();

  DioNetwork() {
    init();
  }

  init() async {
    cacheDir = await getTemporaryDirectory();
  }

  static CancelToken cancelToken = CancelToken();
  static Dio dio({auth = true}) {
    Dio dio = Dio();
    dio.options.baseUrl = apiUrl;
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
    dio.options.sendTimeout = const Duration(seconds: 60);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // print("path ${options.path}");
          // print("data req ${options.data}");
          // print("queryParameters req ${options.queryParameters}");
          if (connectionService.isConnected) {
            if (auth) {
              // يمكنك استخدام GetStorage لتخزين واسترجاع الرمز المميز
              final token = UserTool.getUser().token;
              if (token != null) {
                options.headers["Authorization"] = "Bearer $token";
              }
            }

            // إضافة رؤوس HTTP الأساسية
            options.headers["Accept"] = "application/json";
            options.headers["Content-Type"] = "application/json";

            // إضافة رأس المصادقة إذا كان مطلوباً

            options.cancelToken = cancelToken;
            return handler.next(options);
          } else {
            // CustomSnackBar.showSnackBar('لا يوجد انصال ', 'error');
          }
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(e.response?.data);
          HandleError.handleDioError(e);
          return handler.reject(e);
        },
      ),
    );
    return dio;
  }

  // GET Request
  static Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      final response = await dioInstance.get(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST Request
  static Future<Response> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      final response = await dioInstance.post(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT Request
  static Future<Response> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      final response = await dioInstance.put(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE Request
  static Future<Response> delete({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      final response = await dioInstance.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PATCH Request
  static Future<Response> patch({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      final response = await dioInstance.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Upload File Request
  static Future<Response> uploadFile({
    required String path,
    required String filePath,
    String fieldName = 'file',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (data != null) ...data,
      });

      final response = await dioInstance.post(
        path,
        data: formData,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
        onSendProgress: onSendProgress,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Download File Request
  static Future<Response> downloadFile({
    required String path,
    required String savePath,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      final response = await dioInstance.download(
        path,
        savePath,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Request with Custom Options
  static Future<Response> request({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool auth = true,
    CancelToken? cancelToken,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) async {
    try {
      final dioInstance = dio(auth: auth);

      if (headers != null) {
        dioInstance.options.headers.addAll(headers);
      }

      if (connectTimeout != null) {
        dioInstance.options.connectTimeout = connectTimeout;
      }

      if (receiveTimeout != null) {
        dioInstance.options.receiveTimeout = receiveTimeout;
      }

      if (sendTimeout != null) {
        dioInstance.options.sendTimeout = sendTimeout;
      }

      final response = await dioInstance.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
        cancelToken: cancelToken ?? DioNetwork.cancelToken,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Cancel All Requests
  static void cancelAllRequests() {
    cancelToken.cancel('All requests cancelled');
  }

  // Check if Request is Cancelled
  static bool isRequestCancelled() {
    return cancelToken.isCancelled;
  }
}
