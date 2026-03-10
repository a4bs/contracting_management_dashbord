class CustomerModel {
  int? id;
  String? name;
  String? phone1;
  String? phone2;
  String? address;
  String? idCard;
  num? debit;
  num? credit;
  String? createdAt;
  String? updatedAt;
  List<String>? files;

  CustomerModel({
    this.id,
    this.name,
    this.phone1,
    this.phone2,
    this.address,
    this.idCard,
    this.debit,
    this.credit,
    this.createdAt,
    this.updatedAt,
    this.files,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
    phone1 = json['phone1']?.toString();
    phone2 = json['phone2']?.toString();
    address = json['address'];
    idCard = json['id_card']?.toString();
    debit = _toNum(json['debit']);
    credit = _toNum(json['credit']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['files'] != null) {
      files = <String>[];
      if (json['file_path'] is List) {
        for (var v in json['file_path']) {
          if (v is String) {
            files!.add(v);
          } else if (v is Map && v['link'] != null) {
            files!.add(v['link'].toString());
          }
        }
      }
    }

    if (json['file_path'] != null) {
      files ??= <String>[];
      if (json['file_path'] is String) {
        files!.add(json['file_path']);
      } else if (json['file_path'] is List) {
        for (var v in json['file_path']) {
          if (v is String) files!.add(v);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone1'] = phone1;
    data['phone2'] = phone2;
    data['address'] = address;
    data['id_card'] = idCard;
    data['debit'] = debit;
    data['credit'] = credit;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
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
}
