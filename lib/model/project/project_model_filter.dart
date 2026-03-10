import 'package:contracting_management_dashbord/model/project/project_key.dart';

class ProjectModelFilter {
  String? name;
  int? isEnable;
  int? projectStatusId;
  int? projectTypeId;
  int? perPage;

  ProjectModelFilter({
    this.name,
    this.isEnable,
    this.projectStatusId,
    this.projectTypeId,
    this.perPage,
  });

  factory ProjectModelFilter.fromJson(Map<String, dynamic> json) {
    return ProjectModelFilter(
      name: json[ProjectFilterKey.name],
      isEnable: json[ProjectFilterKey.isEnable],
      projectStatusId: json[ProjectFilterKey.projectStatusId],
      projectTypeId: json[ProjectFilterKey.projectTypeId],
      perPage: json[ProjectFilterKey.perPage],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ProjectFilterKey.name] = name;
    data[ProjectFilterKey.isEnable] = isEnable;
    data[ProjectFilterKey.projectStatusId] = projectStatusId;
    data[ProjectFilterKey.projectTypeId] = projectTypeId;
    data[ProjectFilterKey.perPage] = perPage;
    return data;
  }
}
