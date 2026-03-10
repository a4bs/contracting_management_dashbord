import 'package:contracting_management_dashbord/screen/admin/dashboard_screen.dart';
import 'package:flutter/material.dart';

class AppPages {
  static List<Map<String, dynamic>> get pagesListToAdmin => [
    {
      'title': 'لوحة التقارير',
      'icon': Icons.dashboard_outlined,
      'url': '/dashboard',
      'screen': DashboardScreen(),
      'index': 0,
    },
    {
      'title': 'ادارة الشركات  ',
      'icon': Icons.dashboard_outlined,
      'url': '/dashboard',
      'screen': DashboardScreen(),
      'index': 0,
    },
    {
      'title': 'ادارة الشركات  ',
      'icon': Icons.dashboard_outlined,
      'url': '/dashboard',
      'screen': DashboardScreen(),
      'index': 0,
    },
  ];

  static List<Map<String, dynamic>> get pagesAdmin => pagesListToAdmin.toList();
}
// 1. الرئيسية (Dashboard)
// أول شاشة تظهر عند الدخول

// KPI Cards: إجمالي الشركات، الإيرادات، المستخدمين، التنبيهات
// Line Chart: الإيرادات آخر 12 شهر
// Pie Chart: توزيع أنواع الاشتراكات
// قائمة سريعة: آخر الشركات المسجلة + الشركات المقاربة للانتهاء
// 🏢 2. إدارة الشركات (Companies Management)
// أهم شاشة في لوحة التحكم

// جدول بكل الشركات (اسم، نوع الاشتراك، تاريخ الانتهاء، الحالة)
// فلترة حسب: نوع الاشتراك / الحالة (نشط/منتهي) / التخصص
// أزرار: تجديد الاشتراك / تعطيل شركة / عرض تفاصيلها
// إضافة شركة جديدة
// 👤 3. إدارة المستخدمين (Users Management)
// جدول بكل المستخدمين مع دورهم (Admin/Company/Client)
// فلترة حسب الدور والشركة
// تعديل البيانات / تعطيل حساب
// 💰 4. التقارير المالية (Financial Reports)
// Bar Chart: الإيرادات الشهرية للسنة الحالية
// إجمالي الإيرادات / إيرادات الشهر الحالي
// تقرير مفصل لكل شركة: كم دفعت؟ متى؟
// ⚠️ 5. الاشتراكات والتجديدات (Subscriptions)
// تساعدك على متابعة المال

// قائمة الشركات التي ستنتهي خلال 15 يوم
// قائمة الشركات التي انتهت بالفعل
// إمكانية تمديد اشتراك شركة مباشرة من هنا
// 🔔 6. مركز التنبيهات (Alerts Center)
// قائمة بكل تنبيهات النظام (غير المحلولة أولاً)
// تصفية حسب: الشركة / النوع / التاريخ
// زر "تمييز كمحلول"
// 📊 7. تقارير الاستخدام (Usage Reports)
// أكثر الشركات استهلاكاً للتخزين
// أكثر الشركات نشاطاً (المشاريع / العمليات)
// تقرير ساعات تشغيل الآليات عبر المنصة
// ⚙️ 8. الإعدادات (Settings)
// تغيير بيانات صاحب التطبيق
// إدارة أنواع الاشتراكات وأسعارها
// إعدادات حدود التخزين للشركات
