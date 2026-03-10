import 'package:contracting_management_dashbord/model/archive/archive_type_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';

class ArchiveModel {
  int? id;
  String? title;
  String? details;
  String? date;
  String? createdAt;
  int? projectId;
  int? unitId;
  int? archiveTypeId;
  int? archiveNumber;
  List<String>? files;
  ArchiveTypeModel? archiveType;
  UnitModel? unit;
  ProjectModel? project;

  ArchiveModel({
    this.id,
    this.title,
    this.details,
    this.date,
    this.createdAt,
    this.projectId,
    this.unitId,
    this.archiveTypeId,
    this.archiveNumber,
    this.files,
    this.archiveType,
    this.unit,
    this.project,
  });

  ArchiveModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    title = json['title'];
    details = json['details'];
    date = json['date'];
    createdAt = json['created_at'];
    projectId = _toInt(json['project_id']);
    unitId = _toInt(json['unit_id']);
    archiveTypeId = _toInt(json['archive_type_id']);
    archiveNumber = _toInt(json['archive_number']);

    if (json['archive_type'] != null) {
      archiveType = ArchiveTypeModel.fromJson(json['archive_type']);
    }
    if (json['unit'] != null) {
      unit = UnitModel.fromJson(json['unit']);
    }
    if (json['project'] != null) {
      project = ProjectModel.fromJson(json['project']);
    }

    // Handle files
    files = <String>[];
    if (json['files'] != null) {
      if (json['files'] is List) {
        for (var v in json['files']) {
          if (v is String) {
            files!.add(v);
          } else if (v is Map && v['link'] != null) {
            files!.add(v['link'].toString());
          }
        }
      }
    }

    if (json['file_path'] != null) {
      if (json['file_path'] is String) {
        files!.add(json['file_path']);
      } else if (json['file_path'] is List) {
        for (var v in json['file_path']) {
          if (v is String) files!.add(v);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['details'] = details;
    data['date'] = date;
    data['created_at'] = createdAt;
    data['project_id'] = projectId;
    data['unit_id'] = unitId;
    data['archive_type_id'] = archiveTypeId;
    data['archive_number'] = archiveNumber;

    if (archiveType != null) {
      data['archive_type'] = archiveType!.toJson();
    }
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    if (project != null) {
      data['project'] = project!.toJson();
    }

    return data;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }
}
