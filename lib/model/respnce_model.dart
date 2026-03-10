class ResponseModel {
  var data;
  String? message;
  bool? status;
  bool? is_from_cache;
  bool? is_update_required;

  ResponseModel({
    this.data,
    this.message,
    this.status,
    this.is_from_cache,
    this.is_update_required,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      data: json['data'],
      message: json['message'],
      status: json['status'] == 200 ? true : false,
    );
  }
  Map<String, dynamic> toJson() {
    return {'data': data, 'message': message, 'status': status};
  }
}
