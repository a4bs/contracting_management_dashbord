class BoxModel {
  int? id;
  String? name;
  dynamic isEnable; // Can be int or String
  int? parentId;
  num? billDebit;
  num? customerDebit;
  num? debit;
  num? credit;
  _Project? project;

  BoxModel({
    this.id,
    this.name,
    this.isEnable,
    this.parentId,
    this.billDebit,
    this.customerDebit,
    this.debit,
    this.credit,
    this.project,
  });

  BoxModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    isEnable = json['is_enable'];
    parentId = _toInt(json['parent_id']);
    billDebit = _toNum(json['bill_debit']);
    customerDebit = _toNum(json['customer_debit']);
    debit = _toNum(json['debit']);
    credit = _toNum(json['credit']);
    project = json['project'] != null
        ? new _Project.fromJson(json['project'])
        : null;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is num) return value.toInt();
    return null;
  }

  static num? _toNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) return num.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_enable'] = this.isEnable;
    data['parent_id'] = this.parentId;
    data['bill_debit'] = this.billDebit;
    data['customer_debit'] = this.customerDebit;
    data['debit'] = this.debit;
    data['credit'] = this.credit;
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    return data;
  }
}

class _Project {
  int? id;
  String? name;

  // ignore: unused_element_parameter
  _Project({this.id, this.name});

  _Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
