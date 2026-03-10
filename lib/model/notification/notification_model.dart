import 'dart:convert';

class NotificationModel {
  String? id;
  String? type;
  String? notifiableId;
  String? notifiableType;
  NotificationData? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.id,
    this.type,
    this.notifiableId,
    this.notifiableType,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString(),
      type: json['type'],
      notifiableId: json['notifiable_id']?.toString(),
      notifiableType: json['notifiable_type'],
      data: json['data'] != null ? _parseNotificationData(json['data']) : null,
      readAt: json['read_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['notifiable_id'] = notifiableId;
    data['notifiable_type'] = notifiableType;
    data['data'] = this.data?.toJson();
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  /// Parse notification data that might be a JSON string or Map
  static NotificationData _parseNotificationData(dynamic data) {
    try {
      if (data is String) {
        // Parse JSON string to Map
        final Map<String, dynamic> parsedData = jsonDecode(data);
        return NotificationData.fromJson(parsedData);
      } else if (data is Map<String, dynamic>) {
        // Already a Map, use directly
        return NotificationData.fromJson(data);
      } else {
        // Unexpected type, return null
        return NotificationData();
      }
    } catch (e) {
      // If parsing fails, return empty NotificationData
      return NotificationData();
    }
  }
}

class NotificationData {
  String? message;
  int? bondId;
  bool? isApprove;
  Sender? sender;
  Bond? bond;

  NotificationData({
    this.message,
    this.bondId,
    this.isApprove,
    this.sender,
    this.bond,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      message: json['message'],
      bondId: json['bond_id'],
      isApprove: json['is_approve'],
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      bond: json['bond'] != null ? Bond.fromJson(json['bond']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['bond_id'] = bondId;
    data['is_approve'] = isApprove;
    data['sender'] = sender?.toJson();
    data['bond'] = bond?.toJson();
    return data;
  }
}

class Sender {
  int? id;
  String? username;
  String? fullName;
  String? email;
  dynamic emailVerifiedAt;
  bool? isEnable;
  dynamic userId;
  String? createdAt;
  String? updatedAt;
  String? deviceToken;

  Sender({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.emailVerifiedAt,
    this.isEnable,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deviceToken,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      isEnable: json['is_enable'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deviceToken: json['device_token'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['full_name'] = fullName;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['is_enable'] = isEnable;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['device_token'] = deviceToken;
    return data;
  }
}

class Bond {
  int? id;
  int? amount;
  dynamic isApprove;
  String? title;
  String? note;
  String? createdAt;
  String? updatedAt;
  int? bondTypeId;
  int? userId;
  int? boxId;
  dynamic customerId;
  dynamic isScheduledInstallment;
  String? installmentDateAt;
  int? downPayment;
  dynamic percentageId;
  dynamic filePath;
  BondType? bondType;
  dynamic percentage;
  BondUser? user;
  dynamic customer;
  Box? box;

  Bond({
    this.id,
    this.amount,
    this.isApprove,
    this.title,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.bondTypeId,
    this.userId,
    this.boxId,
    this.customerId,
    this.isScheduledInstallment,
    this.installmentDateAt,
    this.downPayment,
    this.percentageId,
    this.filePath,
    this.bondType,
    this.percentage,
    this.user,
    this.customer,
    this.box,
  });

  factory Bond.fromJson(Map<String, dynamic> json) {
    return Bond(
      id: json['id'],
      amount: json['amount'],
      isApprove: json['is_approve'],
      title: json['title'],
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      bondTypeId: json['bond_type_id'],
      userId: json['user_id'],
      boxId: json['box_id'],
      customerId: json['customer_id'],
      isScheduledInstallment: json['is_scheduled_installment'],
      installmentDateAt: json['installment_date_at'],
      downPayment: json['down_payment'],
      percentageId: json['percentage_id'],
      filePath: json['file_path'],
      bondType: json['bondType'] != null
          ? BondType.fromJson(json['bondType'])
          : null,
      percentage: json['percentage'],
      user: json['user'] != null ? BondUser.fromJson(json['user']) : null,
      customer: json['customer'],
      box: json['box'] != null ? Box.fromJson(json['box']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['is_approve'] = isApprove;
    data['title'] = title;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bond_type_id'] = bondTypeId;
    data['user_id'] = userId;
    data['box_id'] = boxId;
    data['customer_id'] = customerId;
    data['is_scheduled_installment'] = isScheduledInstallment;
    data['installment_date_at'] = installmentDateAt;
    data['down_payment'] = downPayment;
    data['percentage_id'] = percentageId;
    data['file_path'] = filePath;
    data['bondType'] = bondType?.toJson();
    data['percentage'] = percentage;
    data['user'] = user?.toJson();
    data['customer'] = customer;
    data['box'] = box?.toJson();
    return data;
  }
}

class BondType {
  int? id;
  String? name;
  bool? isEnable;
  String? createdAt;
  String? updatedAt;

  BondType({this.id, this.name, this.isEnable, this.createdAt, this.updatedAt});

  factory BondType.fromJson(Map<String, dynamic> json) {
    return BondType(
      id: json['id'],
      name: json['name'],
      isEnable: json['is_enable'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_enable'] = isEnable;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class BondUser {
  int? id;
  String? username;
  String? fullName;
  String? email;
  bool? isEnable;

  BondUser({this.id, this.username, this.fullName, this.email, this.isEnable});

  factory BondUser.fromJson(Map<String, dynamic> json) {
    return BondUser(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      email: json['email'],
      isEnable: json['is_enable'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['full_name'] = fullName;
    data['email'] = email;
    data['is_enable'] = isEnable;
    return data;
  }
}

class Box {
  int? id;
  String? name;
  dynamic isEnable;
  dynamic parentId;
  dynamic projectId;
  int? billDebit;
  int? customerDebit;
  int? debit;
  int? credit;

  Box({
    this.id,
    this.name,
    this.isEnable,
    this.parentId,
    this.projectId,
    this.billDebit,
    this.customerDebit,
    this.debit,
    this.credit,
  });

  factory Box.fromJson(Map<String, dynamic> json) {
    return Box(
      id: json['id'],
      name: json['name'],
      isEnable: json['is_enable'],
      parentId: json['parent_id'],
      projectId: json['project_id'],
      billDebit: json['bill_debit'],
      customerDebit: json['customer_debit'],
      debit: json['debit'],
      credit: json['credit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_enable'] = isEnable;
    data['parent_id'] = parentId;
    data['project_id'] = projectId;
    data['bill_debit'] = billDebit;
    data['customer_debit'] = customerDebit;
    data['debit'] = debit;
    data['credit'] = credit;
    return data;
  }
}
