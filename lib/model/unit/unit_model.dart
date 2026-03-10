import 'package:contracting_management_dashbord/model/customer/customer_model.dart';
import 'package:contracting_management_dashbord/model/percentage/percentage_model.dart';
import 'package:contracting_management_dashbord/model/project/project_model.dart';

class UnitModel {
  int? id;
  String? name;
  String? cost;
  int? projectId;
  ProjectModel? project;
  PercentageModel? percentage;
  List<CustomerModel>? customers;

  UnitModel({
    this.id,
    this.name,
    this.cost,
    this.projectId,
    this.project,
    this.percentage,
    this.customers,
  });

  UnitModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
    cost = (json['cost'] ?? 0).toString();
    projectId = _toInt(json['project_id']);
    project = json['project'] != null
        ? ProjectModel.fromJson(json['project'])
        : null;
    percentage = json['percentage'] != null
        ? PercentageModel.fromJson(json['percentage'])
        : null;
    if (json['customers'] != null) {
      customers = <CustomerModel>[];
      json['customers'].forEach((v) {
        customers!.add(CustomerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cost'] = cost;
    data['project_id'] = projectId;
    if (project != null) {
      data['project'] = project!.toJson();
    }
    if (percentage != null) {
      data['percentage'] = percentage!.toJson();
    }
    if (customers != null) {
      data['customers'] = customers!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  num get totalPayments {
    if (customers == null) return 0;
    return customers!.fold(0, (sum, item) => sum + (item.credit ?? 0));
  }
}
