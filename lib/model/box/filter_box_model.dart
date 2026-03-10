import 'package:contracting_management_dashbord/model/box/box_key.dart';

class FilterBoxModel {
  int? id;
  String? name;
  bool? isEnable;
  int? projectId;
  int? perPage;

  FilterBoxModel({
    this.id,
    this.name,
    this.isEnable,
    this.projectId,
    this.perPage,
  });

  factory FilterBoxModel.fromJson(Map<String, dynamic> json) {
    return FilterBoxModel(
      id: int.tryParse(json[BoxFilterKey.id].toString()),
      name: json[BoxFilterKey.name],
      isEnable: json[BoxFilterKey.isEnable],
      projectId: int.tryParse(json[BoxFilterKey.projectId].toString()),
      perPage: int.tryParse(json[BoxFilterKey.perPage].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data[BoxFilterKey.id] = id;
    if (name != null) data[BoxFilterKey.name] = name;
    if (isEnable != null) data[BoxFilterKey.isEnable] = isEnable;
    if (projectId != null) data[BoxFilterKey.projectId] = projectId;
    if (perPage != null) data[BoxFilterKey.perPage] = perPage;
    return data;
  }
}
