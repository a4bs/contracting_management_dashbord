class ApprovedBoundUser {
  String? approvedAt;
  ApprovedBy? approvedBy;

  ApprovedBoundUser({this.approvedAt, this.approvedBy});

  ApprovedBoundUser.fromJson(Map<String, dynamic> json) {
    approvedAt = json['approved_at'];
    approvedBy = json['approved_by'] != null
        ? new ApprovedBy.fromJson(json['approved_by'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approved_at'] = this.approvedAt;
    if (this.approvedBy != null) {
      data['approved_by'] = this.approvedBy!.toJson();
    }
    return data;
  }
}

class ApprovedBy {
  int? id;
  String? username;
  String? fullName;

  ApprovedBy({this.id, this.username, this.fullName});

  ApprovedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    return data;
  }
}
