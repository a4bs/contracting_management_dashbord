import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// خدمة فحص الاتصال بالإنترنت والخادم
class ConnectionService extends GetxService {
  static ConnectionService get to => Get.find();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // متغيرات الحالة
  final RxBool _isConnected = false.obs;
  final RxBool _isInternetAvailable = false.obs;
  final RxString _connectionType = 'none'.obs;
  final RxBool _isServerReachable = false.obs;

  // Getters
  bool get isConnected => _isConnected.value;
  bool get isInternetAvailable => _isInternetAvailable.value;
  String get connectionType => _connectionType.value;
  bool get isServerReachable => _isServerReachable.value;

  // Streams للاستماع للتغييرات
  Stream<bool> get connectionStream => _isConnected.stream;
  Stream<bool> get internetStream => _isInternetAvailable.stream;
  Stream<String> get connectionTypeStream => _connectionType.stream;
  Stream<bool> get serverReachabilityStream => _isServerReachable.stream;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectionMonitoring();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// تهيئة مراقبة الاتصال
  void _initializeConnectionMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
      onError: (error) {
        _isConnected.value = false;
        _connectionType.value = 'error';
      },
    );

    // فحص الاتصال الأولي
    _checkInitialConnection();
  }

  /// فحص الاتصال الأولي
  Future<void> _checkInitialConnection() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      await _onConnectivityChanged(connectivityResults);
    } catch (e) {
      _isConnected.value = false;
      _connectionType.value = 'error';
    }
  }

  /// معالج تغيير الاتصال
  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    try {
      if (results.isEmpty) {
        _updateConnectionStatus(false, 'none');
        return;
      }

      final result = results.first;
      bool hasConnection = result != ConnectivityResult.none;

      if (hasConnection) {
        _connectionType.value = _getConnectionTypeString(result);
        _isConnected.value = true;

        // فحص توفر الإنترنت
        await _checkInternetConnectivity();
      } else {
        _updateConnectionStatus(false, 'none');
      }
    } catch (e) {
      _updateConnectionStatus(false, 'error');
    }
  }

  /// تحديث حالة الاتصال
  void _updateConnectionStatus(bool connected, String type) {
    _isConnected.value = connected;
    _connectionType.value = type;
    if (!connected) {
      _isInternetAvailable.value = false;
      _isServerReachable.value = false;
    }
  }

  /// الحصول على نوع الاتصال كنص
  String _getConnectionTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'wifi';
      case ConnectivityResult.mobile:
        return 'mobile';
      case ConnectivityResult.ethernet:
        return 'ethernet';
      case ConnectivityResult.bluetooth:
        return 'bluetooth';
      case ConnectivityResult.vpn:
        return 'vpn';
      case ConnectivityResult.other:
        return 'other';
      case ConnectivityResult.none:
        return 'none';
    }
  }

  /// فحص توفر الإنترنت
  Future<bool> _checkInternetConnectivity() async {
    try {
      // محاولة الاتصال بخادم Google DNS
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));

      bool hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      _isInternetAvailable.value = hasInternet;

      if (hasInternet) {
        // فحص إمكانية الوصول للخادم
        await _checkServerReachability();
      } else {
        _isServerReachable.value = false;
      }

      return hasInternet;
    } catch (e) {
      _isInternetAvailable.value = false;
      _isServerReachable.value = false;
      return false;
    }
  }

  /// فحص إمكانية الوصول للخادم
  Future<void> _checkServerReachability() async {
    try {
      // يمكنك تغيير هذا الرابط إلى رابط خادمك
      final uri = Uri.parse('https://www.google.com');
      final client = HttpClient();

      final request = await client
          .getUrl(uri)
          .timeout(const Duration(seconds: 10));
      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );

      _isServerReachable.value =
          response.statusCode >= 200 && response.statusCode < 400;
      client.close();
    } catch (e) {
      _isServerReachable.value = false;
    }
  }

  /// فحص الاتصال يدوياً
  Future<Map<String, dynamic>> checkConnectionManually() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      final hasConnection =
          connectivityResults.isNotEmpty &&
          connectivityResults.first != ConnectivityResult.none;

      bool hasInternet = false;
      bool serverReachable = false;

      if (hasConnection) {
        hasInternet = await _checkInternetConnectivity();
        serverReachable = _isServerReachable.value;
      }

      return {
        'hasConnection': hasConnection,
        'hasInternet': hasInternet,
        'serverReachable': serverReachable,
        'connectionType': hasConnection ? _connectionType.value : 'none',
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'hasConnection': false,
        'hasInternet': false,
        'serverReachable': false,
        'connectionType': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// إعادة تشغيل مراقبة الاتصال
  Future<void> restartConnectionMonitoring() async {
    _connectivitySubscription?.cancel();
    _initializeConnectionMonitoring();
  }

  /// الحصول على حالة الاتصال الحالية
  Map<String, dynamic> getCurrentConnectionStatus() {
    return {
      'isConnected': _isConnected.value,
      'isInternetAvailable': _isInternetAvailable.value,
      'connectionType': _connectionType.value,
      'isServerReachable': _isServerReachable.value,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
