import 'package:contracting_management_dashbord/model/bill/bill_key.dart';

class BillFilter {
  String? note;
  String? installmentDateFrom;
  String? installmentDateTo;
  bool? isScheduledInstallment;
  String? plot;
  int? boxId;
  int? projectId;
  int? unitId;
  int? customer;
  int? id;
  String? createdAtFrom;
  String? createdAtTo;
  int? page;
  int? limit;
  BillFilter({
    this.note,
    this.installmentDateFrom,
    this.installmentDateTo,
    this.isScheduledInstallment, // 1 or 0
    this.plot,
    this.boxId,
    this.projectId,
    this.unitId,
    this.customer,
    this.id,
    this.createdAtFrom,
    this.createdAtTo,
    this.page,
    this.limit,
  });
  factory BillFilter.fromJson(Map<String, dynamic> json) {
    return BillFilter(
      note: json[BillFilterKey.note],
      installmentDateFrom: json[BillFilterKey.installmentDateFrom],
      installmentDateTo: json[BillFilterKey.installmentDateTo],
      isScheduledInstallment: json[BillFilterKey.isScheduledInstallment],
      plot: json[BillFilterKey.plot],
      boxId: json[BillFilterKey.boxId],
      projectId: json[BillFilterKey.projectId],
      unitId: json[BillFilterKey.unitId],
      customer: json[BillFilterKey.customer],
      id: json[BillFilterKey.id],
      createdAtFrom: json[BillFilterKey.createdAtFrom],
      createdAtTo: json[BillFilterKey.createdAtTo],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (note != null) {
      data[BillFilterKey.note] = note;
    }
    if (installmentDateFrom != null) {
      data[BillFilterKey.installmentDateFrom] = installmentDateFrom;
    }
    if (installmentDateTo != null) {
      data[BillFilterKey.installmentDateTo] = installmentDateTo;
    }
    if (isScheduledInstallment != null) {
      data[BillFilterKey.isScheduledInstallment] = isScheduledInstallment!
          ? 1
          : 0;
    }
    if (plot != null) {
      data[BillFilterKey.plot] = plot;
    }
    if (boxId != null) {
      data[BillFilterKey.boxId] = boxId;
    }
    if (projectId != null) {
      data[BillFilterKey.projectId] = projectId;
    }
    if (unitId != null) {
      data[BillFilterKey.unitId] = unitId;
    }
    if (customer != null) {
      data[BillFilterKey.customer] = customer;
    }
    if (id != null) {
      data[BillFilterKey.id] = id;
    }
    if (createdAtFrom != null) {
      data[BillFilterKey.createdAtFrom] = createdAtFrom;
    }
    if (createdAtTo != null) {
      data[BillFilterKey.createdAtTo] = createdAtTo;
    }
    if (page != null) {
      data[BillFilterKey.page] = page;
    }
    if (limit != null) {
      data[BillFilterKey.limit] = limit;
    }
    return data;
  }

  copyWith({
    String? note,
    String? installmentDateFrom,
    String? installmentDateTo,
    bool? isScheduledInstallment,
    String? plot,
    int? boxId,
    int? projectId,
    int? unitId,
    int? customer,
    int? id,
    String? createdAtFrom,
    String? createdAtTo,
    int? page,
    int? limit,
  }) {
    return BillFilter(
      note: note ?? this.note,
      installmentDateFrom: installmentDateFrom ?? this.installmentDateFrom,
      installmentDateTo: installmentDateTo ?? this.installmentDateTo,
      isScheduledInstallment:
          isScheduledInstallment ?? this.isScheduledInstallment,
      plot: plot ?? this.plot,
      boxId: boxId ?? this.boxId,
      projectId: projectId ?? this.projectId,
      unitId: unitId ?? this.unitId,
      customer: customer ?? this.customer,
      id: id ?? this.id,
      createdAtFrom: createdAtFrom ?? this.createdAtFrom,
      createdAtTo: createdAtTo ?? this.createdAtTo,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}
