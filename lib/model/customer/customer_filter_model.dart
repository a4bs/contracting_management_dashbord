class CustomerFilterModel {
  String? name;
  String? phone1;
  String? phone2;
  String? address;
  String? idCard;
  int? page;
  int? limit;

  CustomerFilterModel({
    this.name,
    this.phone1,
    this.phone2,
    this.address,
    this.idCard,
    this.page,
    this.limit,
  });

  CustomerFilterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone1 = json['phone1']?.toString();
    phone2 = json['phone2']?.toString();
    address = json['address'];
    idCard = json['id_card']?.toString();
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['phone1'] = phone1;
    data['phone2'] = phone2;
    data['address'] = address;
    data['id_card'] = idCard;
    data['page'] = page;
    data['limit'] = limit;
    if (name != null) {
      data['name'] = name;
    }
    if (phone1 != null) {
      data['phone1'] = phone1;
    }
    if (phone2 != null) {
      data['phone2'] = phone2;
    }
    if (address != null) {
      data['address'] = address;
    }
    if (idCard != null) {
      data['id_card'] = idCard;
    }
    if (page != null) {
      data['page'] = page;
    }
    if (limit != null) {
      data['limit'] = limit;
    }
    return data;
  }

  copyWith({
    int? id,
    String? name,
    String? phone1,
    String? phone2,
    String? address,
    String? idCard,
    int? page,
    int? limit,
  }) {
    return CustomerFilterModel(
      name: name ?? this.name,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      address: address ?? this.address,
      idCard: idCard ?? this.idCard,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}
