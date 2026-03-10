import 'package:contracting_management_dashbord/model/bond/bond_key.dart';

class FilterBond {
  int? page;
  int? limit;
  int? bondTypeId;
  bool? isDraft;
  int? userId;
  int? approvedBy;
  int? notApprovedBy;
  String? title;
  int? customerId;
  int? boxId;
  int? isScheduledInstallment;
  String? createAtFrom;
  String? createAtTo;
  String? installmentDateFrom;
  String? installmentDateTo;
  int? percentageId;
  int? isComplete;
  int? perPage;
  int? projectId;

  FilterBond({
    this.page,
    this.limit,
    this.bondTypeId,
    this.isDraft,
    this.userId,
    this.approvedBy,
    this.notApprovedBy,
    this.title,
    this.customerId,
    this.boxId,
    this.isScheduledInstallment,
    this.createAtFrom,
    this.createAtTo,
    this.installmentDateFrom,
    this.installmentDateTo,
    this.percentageId,
    this.isComplete,
    this.perPage,
    this.projectId,
  });

  factory FilterBond.fromJson(Map<String, dynamic> json) {
    return FilterBond(
      page: json[BondFilterKey.page],
      limit: json[BondFilterKey.limit],
      projectId: json[BondFilterKey.projectId],
      bondTypeId: json[BondFilterKey.bondTypeId],
      isDraft: json[BondFilterKey.isDraft],
      userId: json[BondFilterKey.userId],
      approvedBy: json[BondFilterKey.approvedBy],
      notApprovedBy: json[BondFilterKey.notApprovedBy],
      title: json[BondFilterKey.title],
      customerId: json[BondFilterKey.customerId],
      boxId: json[BondFilterKey.boxId],
      isScheduledInstallment: json[BondFilterKey.isScheduledInstallment],
      createAtFrom: json[BondFilterKey.createAtFrom],
      createAtTo: json[BondFilterKey.createAtTo],
      installmentDateFrom: json[BondFilterKey.installmentDateFrom],
      installmentDateTo: json[BondFilterKey.installmentDateTo],
      percentageId: json[BondFilterKey.percentageId],
      isComplete: json[BondFilterKey.isComplete] is bool
          ? (json[BondFilterKey.isComplete] ? 1 : 0)
          : json[BondFilterKey.isComplete],
      perPage: json[BondFilterKey.perPage],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (page != null) {
      data[BondFilterKey.page] = page;
    }
    if (limit != null) {
      data[BondFilterKey.limit] = limit;
    }
    if (projectId != null) {
      data[BondFilterKey.projectId] = projectId;
    }
    if (bondTypeId != null) {
      data[BondFilterKey.bondTypeId] = bondTypeId;
    }
    if (userId != null) {
      data[BondFilterKey.userId] = userId;
    }
    if (approvedBy != null) {
      data[BondFilterKey.approvedBy] = approvedBy;
    }
    if (notApprovedBy != null) {
      data[BondFilterKey.notApprovedBy] = notApprovedBy;
    }
    if (title != null) {
      data[BondFilterKey.title] = title;
    }
    if (customerId != null) {
      data[BondFilterKey.customerId] = customerId;
    }
    if (boxId != null) {
      data[BondFilterKey.boxId] = boxId;
    }
    if (isScheduledInstallment != null) {
      data[BondFilterKey.isScheduledInstallment] = isScheduledInstallment;
    }
    if (createAtFrom != null) {
      data[BondFilterKey.createAtFrom] = createAtFrom;
    }
    if (createAtTo != null) {
      data[BondFilterKey.createAtTo] = createAtTo;
    }
    if (installmentDateFrom != null) {
      data[BondFilterKey.installmentDateFrom] = installmentDateFrom;
    }
    if (installmentDateTo != null) {
      data[BondFilterKey.installmentDateTo] = installmentDateTo;
    }
    if (percentageId != null) {
      data[BondFilterKey.percentageId] = percentageId;
    }
    if (isComplete != null) {
      data[BondFilterKey.isComplete] = isComplete;
    }
    if (perPage != null) {
      data[BondFilterKey.perPage] = perPage;
    }
    if (isDraft != null) {
      data[BondFilterKey.isDraft] = isDraft == true ? 1 : 0;
    }
    return data;
  }

  copyWith({
    int? page,
    int? limit,
    int? bondTypeId,
    bool? isDraft,
    int? userId,
    int? approvedBy,
    int? notApprovedBy,
    String? title,
    int? customerId,
    int? boxId,
    int? isScheduledInstallment,
    String? createAtFrom,
    String? createAtTo,
    String? installmentDateFrom,
    String? installmentDateTo,
    int? percentageId,
    int? isComplete,
    int? perPage,
    int? projectId,
  }) {
    return FilterBond(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      bondTypeId: bondTypeId ?? this.bondTypeId,
      isDraft: isDraft ?? this.isDraft,
      userId: userId ?? this.userId,
      approvedBy: approvedBy ?? this.approvedBy,
      notApprovedBy: notApprovedBy ?? this.notApprovedBy,
      title: title ?? this.title,
      customerId: customerId ?? this.customerId,
      boxId: boxId ?? this.boxId,
      isScheduledInstallment:
          isScheduledInstallment ?? this.isScheduledInstallment,
      createAtFrom: createAtFrom ?? this.createAtFrom,
      createAtTo: createAtTo ?? this.createAtTo,
      installmentDateFrom: installmentDateFrom ?? this.installmentDateFrom,
      installmentDateTo: installmentDateTo ?? this.installmentDateTo,
      percentageId: percentageId ?? this.percentageId,
      isComplete: isComplete ?? this.isComplete,
      perPage: perPage ?? this.perPage,
      projectId: projectId ?? this.projectId,
    );
  }
}
