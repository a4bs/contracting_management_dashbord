class ProjectTypeModel {
  int? id;
  String? name;
  bool? isEnable;

  ProjectTypeModel({this.id, this.name, this.isEnable});

  ProjectTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isEnable = json['is_enable'] == 1 || json['is_enable'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_enable'] = isEnable == true ? 1 : 0;
    return data;
  }
}
