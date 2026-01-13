class Agency {
  final int id;
  final String agencyCode;
  final String legalName;
  final String tradeName;
  final String contactPerson;
  final String contactPhone;
  final String contactEmail;
  final String membershipStatus;

  Agency({
    required this.id,
    required this.agencyCode,
    required this.legalName,
    required this.tradeName,
    required this.contactPerson,
    required this.contactPhone,
    required this.contactEmail,
    required this.membershipStatus,
  });

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'],
      agencyCode: json['agency_code'],
      legalName: json['legal_name'],
      tradeName: json['trade_name'],
      contactPerson: json['contact_person'],
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      membershipStatus: json['membership_status'],
    );
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }
}

class ApiResponse {
  final bool success;
  final Meta meta;
  final List<Agency> data;

  ApiResponse({
    required this.success,
    required this.meta,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      meta: Meta.fromJson(json['meta']),
      data: (json['data'] as List).map((i) => Agency.fromJson(i)).toList(),
    );
  }
}
