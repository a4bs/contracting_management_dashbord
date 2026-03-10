class ArchiveTypeModel {
  final int id;
  final String name;
  final bool isEnable;

  ArchiveTypeModel({
    required this.id,
    required this.name,
    this.isEnable = true,
  });

  factory ArchiveTypeModel.fromJson(Map<String, dynamic> json) {
    return ArchiveTypeModel(
      id: json['id'],
      name: json['name'],
      isEnable: json['is_enable'] == 1 || json['is_enable'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'is_enable': isEnable ? 1 : 0};
  }
}
