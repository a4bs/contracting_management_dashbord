class FileUploadModel {
  String? filePath;
  String? link;

  FileUploadModel({this.filePath, this.link});

  FileUploadModel.fromJson(Map<String, dynamic> json) {
    filePath = json['file_path'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file_path'] = filePath;
    data['link'] = link;
    return data;
  }
}
