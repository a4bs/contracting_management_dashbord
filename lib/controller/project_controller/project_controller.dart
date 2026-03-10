import 'package:contracting_management_dashbord/controller/app_controller/page_controller.dart';
import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/box/filter_box_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model_filter.dart';
import 'package:contracting_management_dashbord/model/project/project_type_model.dart';
import 'package:contracting_management_dashbord/model/project_status/project_status_model.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';
import 'package:contracting_management_dashbord/repo/box_repo.dart';
import 'package:contracting_management_dashbord/repo/project_repo.dart';
import 'package:contracting_management_dashbord/repo/project_status_repo.dart';
import 'package:contracting_management_dashbord/repo/unit_repo.dart';
import 'package:contracting_management_dashbord/widget/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final ProjectRepo _repo = ProjectRepo();
  final BoxRepo _boxRepo = BoxRepo();
  final UnitRepo _unitRepo = UnitRepo();
  final ProjectStatusRepo _projectStatusRepo = ProjectStatusRepo();

  final PaginationController<ProjectModel> projectDataController =
      PaginationController<ProjectModel>();
  var selectedProject = ProjectModel().obs;
  var selectedUnit = UnitModel().obs;
  var isShowUnitConfig = false.obs;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> formKeyToType =
      GlobalKey<FormBuilderState>();
  // Projects
  Future<List<ProjectModel>?> getAllProjects() async {
    List<ProjectModel>? projects;
    try {
      final response = await _repo.getAllProjects();
      projects = (response.data as List<dynamic>)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return projects;
  }

  Future<ProjectModel?> getProjectById(String id) async {
    ProjectModel? project;
    try {
      final response = await _repo.getProjectById(id);
      project = ProjectModel.fromJson(response.data);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
    return project;
  }

  addProject(data) async {
    final response = await _repo.addProject(data);
    ProjectModel project = ProjectModel.fromJson(response.data);
    projectDataController.addItem(project);
    Get.back();
    CustomToast.showInfo(
      title: "تم إضافة المشروع",
      description: response.message,
    );
  }

  updateProject(String id, data) async {
    try {
      final response = await _repo.updateProject(id, data);
      ProjectModel project = ProjectModel.fromJson(response.data);
      int index = projectDataController.items.indexWhere(
        (element) => element.id.toString() == id,
      );
      if (index != -1) {
        projectDataController.updateItem(index, project);
      }
      Get.back();

      CustomToast.showInfo(
        title: "تم تحديث المشروع",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteProject(String id) async {
    try {
      final response = await _repo.deleteProject(id);
      projectDataController.removeItem(
        projectDataController.items.indexWhere((element) => element.id == id),
      );
      CustomToast.showInfo(
        title: "تم حذف المشروع",
        description: response.message,
      );
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  Future<List<ProjectModel>?> getProjectByFilter(
    ProjectModelFilter filter,
  ) async {
    List<ProjectModel> projects = [];
    try {
      final response = await _repo.getProjectByFilter(filter);
      projects = (response.data as List<dynamic>)
          .map((e) => ProjectModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return projects;
    }
    return projects;
  }

  Future<BoxModel?> getAllBoxes(FilterBoxModel filterBox) async {
    try {
      final response = await _boxRepo.filterBox(filterBox);
      BoxModel box = BoxModel.fromJson(response.data[0]);
      return box;
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return null;
    }
  }

  Future<List<UnitModel>?> getAllUnits(String id) async {
    List<UnitModel> units = [];
    try {
      final response = await _unitRepo.getUnitsByProject(id);
      units = (response.data as List<dynamic>)
          .map((e) => UnitModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return units;
    }
    return units;
  }

  void checkShowUnitConfig(dynamic typeId) {
    if (typeId is int) {
      isShowUnitConfig.value = (typeId == 2);
    } else {
      isShowUnitConfig.value = false;
    }
  }

  Future<List<ProjectStatusModel>?> getAllProjectStatus() async {
    List<ProjectStatusModel> projectStatus = [];
    try {
      final response = await _projectStatusRepo.getAllProjectStatus();
      projectStatus = (response.data as List<dynamic>)
          .map((e) => ProjectStatusModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return projectStatus;
    }
    return projectStatus;
  }

  // ----------------------------------------------------------------------------
  // Project Type
  // ----------------------------------------------------------------------------
  final PaginationController<ProjectTypeModel> projectTypeDataController =
      PaginationController<ProjectTypeModel>();
  Future<List<ProjectTypeModel>?> getAllProjectTypes() async {
    List<ProjectTypeModel> projectTypes = [];
    try {
      final response = await _repo.getAllProjectTypes();
      projectTypes = (response.data as List<dynamic>)
          .map((e) => ProjectTypeModel.fromJson(e))
          .toList();
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
      return projectTypes;
    }
    return projectTypes;
  }

  addProjectType(data) async {
    try {
      final response = await _repo.addProjectType(data);
      CustomToast.showSuccess(title: "     تم", description: response.message);
      ProjectTypeModel newdata = ProjectTypeModel.fromJson(response.data);
      projectTypeDataController.addItem(newdata);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  updateProjectType(String id, data) async {
    try {
      final response = await _repo.updateProjectType(id, data);
      CustomToast.showInfo(title: "تم", description: response.message);
      ProjectTypeModel newdata = ProjectTypeModel.fromJson(response.data);
      int index = projectTypeDataController.items.indexWhere(
        (e) => e.id.toString() == id,
      );
      if (index != -1) {
        projectTypeDataController.updateItem(index, newdata);
      }
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }

  deleteProjectType(String id) async {
    try {
      final response = await _repo.deleteProjectType(id);
      CustomToast.showInfo(title: "تم", description: response.message);
    } catch (e) {
      CustomToast.showInfo(title: "خطأ", description: e.toString());
    }
  }
}
