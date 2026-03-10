class PercentageModel {
  final int? id;
  final String name;
  final int percent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PercentageModel({
    this.id,
    required this.name,
    required this.percent,
    this.createdAt,
    this.updatedAt,
  });

  factory PercentageModel.fromJson(Map<String, dynamic> json) {
    return PercentageModel(
      id: json['id'],
      name: json['name'] ?? '',
      percent: int.tryParse(json['percent'].toString()) ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'percent': percent,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  PercentageModel copyWith({
    int? id,
    String? name,
    int? percent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PercentageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      percent: percent ?? this.percent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
