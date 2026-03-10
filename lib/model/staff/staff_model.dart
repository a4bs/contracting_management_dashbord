import 'package:contracting_management_dashbord/model/staff/staff_key.dart';

class StaffModel {
  int? id;
  String? name;
  String? job;

  StaffModel({this.id, this.name, this.job});

  StaffModel.fromJson(Map<String, dynamic> json) {
    id = json[StaffGetKey.id];
    name = json[StaffGetKey.name];
    job = json[StaffGetKey.job];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[StaffGetKey.id] = id;
    data[StaffGetKey.name] = name;
    data[StaffGetKey.job] = job;
    return data;
  }
}
