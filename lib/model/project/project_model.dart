class ProjectModel {
  int? id;
  String? name;
  String? cost;
  int? isEnable;
  int? projectStatusId;
  int? projectTypeId;
  num? debit;
  num? credit;
  num? billDebit;
  num? balance;
  int? unitsCount;
  int? soldUnitsCount;
  _ProjectType? projectType;
  _ProjectStatus? projectStatus;
  int? boxId;

  ProjectModel({
    this.id,
    this.name,
    this.cost,
    this.isEnable,
    this.projectStatusId,
    this.projectTypeId,
    this.debit,
    this.credit,
    this.billDebit,
    this.balance,
    this.unitsCount,
    this.soldUnitsCount,
    this.projectType,
    this.projectStatus,
    this.boxId,
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cost = json['cost'];
    isEnable = json['is_enable'] == true ? 1 : 0;
    projectStatusId = json['project_status_id'];
    projectTypeId = json['project_type_id'];
    debit = json['debit'];
    credit = json['credit'];
    billDebit = json['bill_debit'];
    balance = json['balance'];
    unitsCount = json['units_count'];
    soldUnitsCount = json['sold_units_count'];
    projectType = json['projectType'] != null
        ? _ProjectType.fromJson(json['projectType'])
        : null;
    projectStatus = json['projectStatus'] != null
        ? _ProjectStatus.fromJson(json['projectStatus'])
        : null;
    boxId = json['box_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cost'] = cost;
    data['is_enable'] = isEnable;
    data['project_status_id'] = projectStatusId;
    data['project_type_id'] = projectTypeId;
    data['debit'] = debit;
    data['credit'] = credit;
    data['bill_debit'] = billDebit;
    data['balance'] = balance;
    data['units_count'] = unitsCount;
    data['sold_units_count'] = soldUnitsCount;
    data['box_id'] = boxId;
    if (projectType != null) {
      data['projectType'] = projectType!.toJson();
    }
    if (projectStatus != null) {
      data['projectStatus'] = projectStatus!.toJson();
    }

    return data;
  }
}

class _ProjectType {
  int? id;
  String? name;
  // ignore: unused_element_parameter
  _ProjectType({this.id, this.name});

  _ProjectType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class _ProjectStatus {
  int? id;
  String? name;
  // ignore: unused_element_parameter
  _ProjectStatus({this.id, this.name});

  _ProjectStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
