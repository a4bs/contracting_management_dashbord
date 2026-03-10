import 'package:contracting_management_dashbord/constant/app_key.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageService {
  static final GetStorage _storage = GetStorage();

  static Future<void> init() async {
    await GetStorage.init();
  }

  static Future<void> saveData(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  static T? getData<T>(String key) {
    return _storage.read<T>(key);
  }

  static T getDataOrDefault<T>(String key, T defaultValue) {
    return _storage.read<T>(key) ?? defaultValue;
  }

  static bool hasData(String key) {
    return _storage.hasData(key);
  }

  static Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  static Future<void> clearAll() async {
    await _storage.erase();
  }

  static List<String> getAllKeys() {
    return _storage.getKeys().toList();
  }

  // التحقق من اتصال التخزين
  static bool isStorageReady() {
    try {
      _storage.read('test_key');
      return true;
    } catch (e) {
      return false;
    }
  }

  // حفظ البيانات النصية
  static Future<void> saveString(String key, String value) async {
    await _storage.write(key, value);
  }

  // استرجاع البيانات النصية
  static String? getString(String key) {
    return _storage.read<String>(key);
  }

  // استرجاع البيانات النصية مع قيمة افتراضية
  static String getStringOrDefault(String key, String defaultValue) {
    return _storage.read<String>(key) ?? defaultValue;
  }

  // حفظ البيانات الرقمية
  static Future<void> saveInt(String key, int value) async {
    await _storage.write(key, value);
  }

  // استرجاع البيانات الرقمية
  static int? getInt(String key) {
    return _storage.read<int>(key);
  }

  // استرجاع البيانات الرقمية مع قيمة افتراضية
  static int getIntOrDefault(String key, int defaultValue) {
    return _storage.read<int>(key) ?? defaultValue;
  }

  // حفظ البيانات العشرية
  static Future<void> saveDouble(String key, double value) async {
    await _storage.write(key, value);
  }

  // استرجاع البيانات العشرية
  static double? getDouble(String key) {
    return _storage.read<double>(key);
  }

  // استرجاع البيانات العشرية مع قيمة افتراضية
  static double getDoubleOrDefault(String key, double defaultValue) {
    return _storage.read<double>(key) ?? defaultValue;
  }

  // حفظ البيانات المنطقية
  static Future<void> saveBool(String key, bool value) async {
    await _storage.write(key, value);
  }

  // استرجاع البيانات المنطقية
  static bool? getBool(String key) {
    return _storage.read<bool>(key);
  }

  // استرجاع البيانات المنطقية مع قيمة افتراضية
  static bool getBoolOrDefault(String key, bool defaultValue) {
    return _storage.read<bool>(key) ?? defaultValue;
  }

  // حفظ قائمة البيانات
  static Future<void> saveList(String key, List<dynamic> value) async {
    await _storage.write(key, value);
  }

  // استرجاع قائمة البيانات
  static List<dynamic>? getList(String key) {
    return _storage.read<List<dynamic>>(key);
  }

  // استرجاع قائمة البيانات مع قيمة افتراضية
  static List<dynamic> getListOrDefault(
    String key,
    List<dynamic> defaultValue,
  ) {
    return _storage.read<List<dynamic>>(key) ?? defaultValue;
  }

  // حفظ خريطة البيانات
  static Future<void> saveMap(String key, Map<String, dynamic> value) async {
    await _storage.write(key, value);
  }

  // استرجاع خريطة البيانات
  static Map<String, dynamic>? getMap(String key) {
    return _storage.read<Map<String, dynamic>>(key);
  }

  // استرجاع خريطة البيانات مع قيمة افتراضية
  static Map<String, dynamic> getMapOrDefault(
    String key,
    Map<String, dynamic> defaultValue,
  ) {
    return _storage.read<Map<String, dynamic>>(key) ?? defaultValue;
  }

  // حفظ بيانات المستخدم
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(AppKeys.userInfo, userData);
  }

  // استرجاع بيانات المستخدم
  static Map<String, dynamic>? getUserData() {
    return _storage.read<Map<String, dynamic>>(AppKeys.userInfo);
  }

  // حذف بيانات المستخدم
  static Future<void> removeUserData() async {
    await _storage.remove(AppKeys.userInfo);
  }

  // حفظ إعدادات التطبيق
  static Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    await _storage.write('app_settings', settings);
  }

  // استرجاع إعدادات التطبيق
  static Map<String, dynamic>? getAppSettings() {
    return _storage.read<Map<String, dynamic>>('app_settings');
  }

  // حفظ إعداد معين
  static Future<void> saveSetting(String key, dynamic value) async {
    Map<String, dynamic> settings = getAppSettings() ?? {};
    settings[key] = value;
    await saveAppSettings(settings);
  }

  // استرجاع إعداد معين
  static T? getSetting<T>(String key) {
    Map<String, dynamic>? settings = getAppSettings();
    return settings?[key] as T?;
  }

  // استرجاع إعداد معين مع قيمة افتراضية
  static T getSettingOrDefault<T>(String key, T defaultValue) {
    T? value = getSetting<T>(key);
    return value ?? defaultValue;
  }

  // حفظ رمز الوصول (Token)
  static Future<void> saveToken(String token) async {
    await _storage.write('auth_token', token);
  }

  // استرجاع رمز الوصول
  static String? getToken() {
    return _storage.read<String>('auth_token');
  }

  // حذف رمز الوصول
  static Future<void> removeToken() async {
    await _storage.remove('auth_token');
  }

  // التحقق من تسجيل الدخول
  static bool isLoggedIn() {
    return _storage.hasData('auth_token') && getToken() != null;
  }

  // تسجيل الخروج (حذف جميع بيانات المستخدم)
  static Future<void> logout() async {
    await removeToken();
    await removeUserData();
  }

  // الحصول على حجم التخزين المستخدم
  static int getStorageSize() {
    return _storage.getKeys().length;
  }
}
