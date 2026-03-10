import '../user/user_model.dart';
class NotificationReceiversModel {
  int? id;
  String? userId;
  bool? isEnabled;
  String? createdAt;
  String? updatedAt;
  UserModel? user;

  NotificationReceiversModel({
    this.id,
    this.userId,
    this.isEnabled,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory NotificationReceiversModel.fromJson(Map<String, dynamic> json) {
    return NotificationReceiversModel(
      id: json['id'],
      userId: json['user_id']?.toString(), // Ensure string conversion
      isEnabled: json['is_enabled'] == 1 || json['is_enabled'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['is_enabled'] = isEnabled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
