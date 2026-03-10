class UserModel {
  int? id;
  String? username;
  String? fullName;
  String? email;
  bool? isEnable;
  String? token;
  List<String>? role;
  List<PermissionModel>? permissions;

  UserModel({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.isEnable,
    this.token,
    this.role,
    this.permissions,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['full_name'];
    email = json['email'];
    isEnable = json['is_enable'];
    token = json['token'];
    if (json['role'] != null) {
      role = List<String>.from(json['role']);
    }
    if (json['permissions'] != null) {
      permissions = <PermissionModel>[];
      json['permissions'].forEach((v) {
        permissions!.add(PermissionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['full_name'] = fullName;
    data['email'] = email;
    data['is_enable'] = isEnable;
    data['token'] = token;
    data['role'] = role;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PermissionModel {
  int? id;
  String? name;
  String? displayName;

  PermissionModel({this.id, this.name, this.displayName});

  PermissionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['display_name'] = displayName;
    return data;
  }
}
