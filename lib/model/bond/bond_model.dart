import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/model/staff/staff_model.dart';

class BondModel {
  int? id;
  String? amount;
  bool? isApprove;
  String? title;
  String? note;
  String? createdAt;
  String? updatedAt;
  String? installmentDateAt;
  int? bondTypeId;
  int? userId;
  int? projectId;
  int? boxId;
  String? downPayment;
  String? filePath;
  List<String>? filePaths;
  String? link;
  int? billId;
  int? customerId;
  int? percentageId;
  CustomerModel? customer;
  StaffModel? staff;
  BoxModel? box;

  // Approval details
  List<BondApproval>? approvals;

  // Computed property compatibility with legacy code
  int? get approvedBy =>
      approvals?.isNotEmpty == true ? approvals!.first.approvedBy : null;
  String? get approvedAt =>
      approvals?.isNotEmpty == true ? approvals!.first.approvedAt : null;
  List<Map<String, dynamic>>? get approvalList =>
      approvals?.map((e) => e.toJson()).toList();

  BondModel({
    this.id,
    this.amount,
    this.isApprove,
    this.title,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.installmentDateAt,
    this.bondTypeId,
    this.userId,
    this.projectId,
    this.boxId,
    this.downPayment,
    this.filePath,
    this.filePaths,
    this.link,
    this.billId,
    this.customerId,
    this.percentageId,
    this.customer,
    this.staff,
    this.box,
    this.approvals,
  });

  BondModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = (json['amount'] ?? 0).toString();
    downPayment = (json['down_payment'] ?? 0).toString();
    projectId = json['project_id'] != null
        ? int.tryParse(json['project_id'].toString())
        : null;
    if (json['staff'] != null && json['staff'] is Map) {
      staff = StaffModel.fromJson(json['staff']);
    }
    if (json['is_approve'] != null) {
      if (json['is_approve'] is bool) {
        isApprove = json['is_approve'];
      } else if (json['is_approve'] is List) {
        final list = json['is_approve'] as List;
        if (list.isNotEmpty) {
          isApprove = true;
          approvals = list.map((e) => BondApproval.fromJson(e)).toList();
        } else {
          isApprove = false;
          approvals = [];
        }
      } else if (json['is_approve'] is Map) {
        isApprove = true;
        approvals = [BondApproval.fromJson(json['is_approve'])];
      } else if (json['is_approve'] is int) {
        isApprove = json['is_approve'] == 1;
      } else {
        isApprove =
            json['is_approve'] == 1 ||
            json['is_approve'] == '1' ||
            json['is_approve'] == 'true';
      }
    }

    if (json['box'] != null && json['box'] is Map) {
      box = BoxModel.fromJson(json['box']);
    }
    title = json['title']?.toString();
    installmentDateAt = json['installment_date_at'];
    note = json['note']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bondTypeId = int.tryParse(json['bond_type_id'].toString());
    userId = int.tryParse(json['user_id'].toString());
    boxId = int.tryParse(json['box_id'].toString());
    customerId = int.tryParse(json['customer_id'].toString());
    percentageId = int.tryParse(json['percentage_id'].toString());
    if (json['customer'] != null && json['customer'] is Map) {
      customer = CustomerModel.fromJson(json['customer']);
    }

    // Handle file_path as array or string
    if (json['file_path'] != null) {
      if (json['file_path'] is List) {
        final list = json['file_path'] as List;
        if (list.isNotEmpty) {
          filePaths = [];
          for (var item in list) {
            if (item is String) {
              filePaths!.add(item);
            } else if (item is Map && item['file_path'] != null) {
              filePaths!.add(item['file_path'].toString());
            }
          }

          // Fallback logic for legacy fields from first item
          final first = list.first;
          if (first is Map) {
            filePath = first['file_path'];
            link = first['link'];
          } else {
            filePath = first.toString();
            link = first.toString();
          }
        }
      } else if (json['file_path'] is String) {
        filePath = json['file_path'];
        filePaths = [filePath!];
      }
    }

    // Fallback for link if not set from file_path array
    if (link == null && json['link'] != null) {
      link = json['link'];
    }

    // Fallback for 'files' array (like CustomerModel)
    if (json['files'] != null &&
        json['files'] is List &&
        (json['files'] as List).isNotEmpty) {
      final filesList = json['files'] as List;

      // Populate filePaths if empty
      if (filePaths == null || filePaths!.isEmpty) {
        filePaths = [];
        for (var item in filesList) {
          if (item is String) {
            filePaths!.add(item);
          } else if (item is Map && item['link'] != null) {
            filePaths!.add(item['link'].toString());
          }
        }
      }

      if (link == null) {
        final firstFile = filesList.first;
        if (firstFile is String) {
          link = firstFile;
          filePath = firstFile;
        } else if (firstFile is Map && firstFile['link'] != null) {
          link = firstFile['link'];
          filePath = firstFile['file_path'] ?? link;
        }
      }
    }

    billId = int.tryParse(json['bill_id']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['down_payment'] = downPayment;
    data['is_approve'] = isApprove;
    data['title'] = title;
    data['installment_date_at'] = installmentDateAt;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bond_type_id'] = bondTypeId;
    data['user_id'] = userId;
    data['box_id'] = boxId;
    data['staff'] = staff?.toJson();
    data['bill_id'] = billId;
    data['customer_id'] = customerId;
    data['percentage_id'] = percentageId;
    data['box'] = box?.toJson();

    // Serialize approvals
    if (approvals != null && approvals!.isNotEmpty) {
      data['is_approve'] = approvals!.map((e) => e.toJson()).toList();
    }

    // Prefer sending list if available, otherwise single path
    if (filePaths != null && filePaths!.isNotEmpty) {
      data['file_path'] = filePaths;
    } else if (filePath != null) {
      data['file_path'] = filePath;
    }

    if (link != null) data['link'] = link;
    if (customer != null) data['customer'] = customer!.toJson();
    return data;
  }

  // Helper methods for approval system

  /// Get total number of approvals
  int get approvalsCount {
    return approvals?.length ?? 0;
  }

  /// Check if a specific user has already approved
  bool hasUserApproved(int userId) {
    if (approvals == null || approvals!.isEmpty) return false;
    return approvals!.any((approval) => approval.approvedBy == userId);
  }

  /// Check if user can approve this bond
  /// User can approve if:
  /// 1. Has the approve-bond permission (ID: 27)
  /// 2. Hasn't approved yet
  bool canUserApprove(int userId, List<int> userPermissions) {
    // Check if user has approve-bond permission (ID: 27)
    if (!userPermissions.contains(27)) return false;

    // Check if user hasn't approved yet
    if (hasUserApproved(userId)) return false;

    return true;
  }

  /// Get list of user IDs who approved
  List<int> get approvedUserIds {
    if (approvals == null || approvals!.isEmpty) return [];
    return approvals!
        .map((approval) => approval.approvedBy)
        .where((id) => id != null)
        .cast<int>()
        .toList();
  }
}

class BondApproval {
  int? approvedBy;
  String? approvedAt;

  BondApproval({this.approvedBy, this.approvedAt});

  BondApproval.fromJson(Map<String, dynamic> json) {
    approvedBy = int.tryParse(json['approved_by'].toString());
    approvedAt = json['approved_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approved_by'] = approvedBy;
    data['approved_at'] = approvedAt;
    return data;
  }
}
