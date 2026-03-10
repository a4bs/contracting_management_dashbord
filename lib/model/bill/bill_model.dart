import 'package:contracting_management_dashbord/model/box/box_model.dart';
import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/model/unit/unit_model.dart';

class BillModel {
  int? id;
  String? plot;
  String? downPayment;
  String? salePrice;
  bool? isScheduledInstallment;
  String? installmentDateAt;
  String? note;
  String? createdAt;
  String? updatedAt;
  int? customerId;
  int? unitId;
  int? boxId;
  CustomerModel? customer;
  UnitModel? unit;
  BoxModel? box;
  int? projectId;
  List<int>? bondIds = [];
  BillModel({
    this.id,
    this.plot,
    this.downPayment,
    this.salePrice,
    this.isScheduledInstallment,
    this.installmentDateAt,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.unitId,
    this.boxId,
    this.customer,
    this.unit,
    this.box,
    this.projectId,
    this.bondIds,
  });

  BillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plot = json['plot']?.toString();
    downPayment = (json['down_payment'] ?? 0).toString();
    salePrice = (json['sale_price'] ?? 0).toString();
    projectId = json['project_id'];
    bondIds = json['bond_ids'] != null ? List<int>.from(json['bond_ids']) : [];
    // Handle is_scheduled_installment
    if (json['is_scheduled_installment'] != null) {
      if (json['is_scheduled_installment'] is bool) {
        isScheduledInstallment = json['is_scheduled_installment'];
      } else {
        isScheduledInstallment =
            json['is_scheduled_installment'] == 1 ||
            json['is_scheduled_installment'] == '1';
      }
    }

    installmentDateAt = json['installment_date_at'];
    note = json['note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerId = json['customer_id'];
    unitId = json['unit_id'];
    boxId = json['box_id'];

    if (json['customer'] != null && json['customer'] is Map<String, dynamic>) {
      customer = CustomerModel.fromJson(json['customer']);
    }
    if (json['unit'] != null && json['unit'] is Map<String, dynamic>) {
      unit = UnitModel.fromJson(json['unit']);
    }
    if (json['box'] != null && json['box'] is Map<String, dynamic>) {
      box = BoxModel.fromJson(json['box']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plot'] = plot;
    data['down_payment'] = downPayment;
    data['sale_price'] = salePrice;
    data['is_scheduled_installment'] = isScheduledInstallment;
    data['installment_date_at'] = installmentDateAt;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['customer_id'] = customerId;
    data['unit_id'] = unitId;
    data['box_id'] = boxId;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (unit != null) {
      data['unit'] = unit!.toJson();
    }
    if (box != null) {
      data['box'] = box!.toJson();
    }
    data['bond_ids'] = bondIds;
    return data;
  }
}
