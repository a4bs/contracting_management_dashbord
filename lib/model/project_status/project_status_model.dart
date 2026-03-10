import 'project_status_key.dart';

class ProjectStatusModel {
  int? id;
  String? name;
  bool? isEnable;

  ProjectStatusModel({this.id, this.name, this.isEnable});

  ProjectStatusModel.fromJson(Map<String, dynamic> json) {
    id = json[ProjectStatusGetKey.id];
    name = json[ProjectStatusGetKey.name];
    isEnable = json[ProjectStatusGetKey.isEnable];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ProjectStatusGetKey.id] = id;
    data[ProjectStatusGetKey.name] = name;
    data[ProjectStatusGetKey.isEnable] = isEnable;
    return data;
  }
}
