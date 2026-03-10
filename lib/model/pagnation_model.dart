class PaginationModel {
  final List<dynamic> data;
  final PaginationInfo pagination;

  PaginationModel({
    required this.data,
    required this.pagination,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      data: json['data'] ?? [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationInfo {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  PaginationInfo({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
      'from': from,
      'to': to,
    };
  }
}
