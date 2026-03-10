class UserModel {
  int? id;
  String? username;
  String? email;
  String? role;
  Null? companyId;
  String? token;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.role,
    this.companyId,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    companyId = json['company_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['role'] = this.role;
    data['company_id'] = this.companyId;
    data['token'] = this.token;
    return data;
  }
}
