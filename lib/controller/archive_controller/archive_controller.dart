import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/model/archive/archiv_filter_model.dart';
import 'package:contracting_management_dashbord/model/archive/archive_model.dart';
import 'package:contracting_management_dashbord/model/archive/archive_type_model.dart';
import 'package:contracting_management_dashbord/repo/archive_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ArchiveController extends GetxController {
  final ArchiveRepo _repo = ArchiveRepo();
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final PaginationController<ArchiveModel> archivePaginationController =
      PaginationController<ArchiveModel>();
  var selectedArchive = ArchiveModel().obs;
  var filterArchive = ArchiveFilterModel().obs;
  var currentPage = 0.obs;
  PageController pageController = PageController();

  Future<List<ArchiveModel>?> getAllArchives() async {
    List<ArchiveModel> archives = [];
    try {
      final response = await _repo.getAllArchives();
      archives = (response.data as List)
          .map((e) => ArchiveModel.fromJson(e))
          .toList();
      return archives;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return [];
  }

  Future<ArchiveModel?> getArchiveById(id) async {
    try {
      final response = await _repo.getArchiveById(id);
      return ArchiveModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return null;
    }
  }

  addArchive(data) async {
    try {
      final response = await _repo.addArchive(data);
      archivePaginationController.addItem(ArchiveModel.fromJson(response.data));
      CustomToast.showInfo(
        title: "تم إضافة الأرشيف",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateArchive(id, data) async {
    try {
      final response = await _repo.updateArchive(id, data);
      int index = archivePaginationController.items.indexWhere(
        (element) => element.id == id,
      );
      if (index != -1) {
        archivePaginationController.updateItem(
          index,
          ArchiveModel.fromJson(response.data),
        );
      }
      CustomToast.showInfo(
        title: "تم تحديث الأرشيف",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteArchive(id) async {
    try {
      final response = await _repo.deleteArchive(id);
      int index = archivePaginationController.items.indexWhere(
        (element) => element.id == id,
      );
      if (index != -1) {
        archivePaginationController.removeItem(index);
      }
      CustomToast.showInfo(
        title: "تم حذف الأرشيف",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<List<ArchiveModel>?> filterArchives(
    ArchiveFilterModel filterData,
  ) async {
    try {
      final response = await _repo.filterArchives(filterData);
      List<ArchiveModel> archives = (response.data as List)
          .map((e) => ArchiveModel.fromJson(e))
          .toList();
      archivePaginationController.items.assignAll(archives);
      return archives;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return [];
    }
  }

  uploadArchiveFile(data) async {
    try {
      final response = await _repo.uploadArchiveFile(data);
      CustomToast.showInfo(
        title: "تم رفع الملف",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  // --------- archiv type
  final PaginationController<ArchiveTypeModel> archiveTypePaginationController =
      PaginationController<ArchiveTypeModel>();
  Future<List<ArchiveTypeModel>> getArchiveTypes() async {
    try {
      final response = await _repo.getArchiveTypes();
      return (response.data as List)
          .map((e) => ArchiveTypeModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return [];
  }

  addArchiveType(data) async {
    try {
      final response = await _repo.addArchiveType(data);
      archiveTypePaginationController.addItem(
        ArchiveTypeModel.fromJson(response.data),
      );
      CustomToast.showInfo(
        title: "تم إضافة الأرشيف",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateArchiveType(String id, data) async {
    try {
      final response = await _repo.updateArchiveType(id, data);
      CustomToast.showInfo(title: "تم", description: response.message);
      ArchiveTypeModel newdata = ArchiveTypeModel.fromJson(response.data);
      int index = archiveTypePaginationController.items.indexWhere(
        (e) => e.id.toString() == id,
      );
      if (index != -1) {
        archiveTypePaginationController.updateItem(index, newdata);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
