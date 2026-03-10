import 'archive_key.dart';

class ArchiveFilterModel {
  String? title;
  String? details;
  String? dateFrom;
  String? dateTo;
  String? archiveNumber;
  int? archiveTypeId;
  int? projectId;
  int? unitId;

  ArchiveFilterModel({
    this.title,
    this.details,
    this.dateFrom,
    this.dateTo,
    this.archiveNumber,
    this.archiveTypeId,
    this.projectId,
    this.unitId,
  });

  ArchiveFilterModel.fromJson(Map<String, dynamic> json) {
    title = json[ArchiveFilterKey.title];
    details = json[ArchiveFilterKey.details];
    dateFrom = json[ArchiveFilterKey.dateFrom];
    dateTo = json[ArchiveFilterKey.dateTo];
    archiveNumber = json[ArchiveFilterKey.archiveNumber];
    archiveTypeId = _toInt(json[ArchiveFilterKey.archiveTypeId]);
    projectId = _toInt(json[ArchiveFilterKey.projectId]);
    unitId = _toInt(json[ArchiveFilterKey.unitId]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) data[ArchiveFilterKey.title] = title;
    if (details != null) data[ArchiveFilterKey.details] = details;
    if (dateFrom != null) data[ArchiveFilterKey.dateFrom] = dateFrom;
    if (dateTo != null) data[ArchiveFilterKey.dateTo] = dateTo;
    if (archiveNumber != null)
      data[ArchiveFilterKey.archiveNumber] = archiveNumber;
    if (archiveTypeId != null)
      data[ArchiveFilterKey.archiveTypeId] = archiveTypeId;
    if (projectId != null) data[ArchiveFilterKey.projectId] = projectId;
    if (unitId != null) data[ArchiveFilterKey.unitId] = unitId;
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
