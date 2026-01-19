
class DistrictResponse {
  final String message;
  final List<DistrictModel> data;

  DistrictResponse({required this.message, required this.data});

  factory DistrictResponse.fromJson(Map<String, dynamic> json) {
    return DistrictResponse(
      message: json['message'] ?? "",
      data: (json['data'] as List)
          .map((item) => DistrictModel.fromJson(item))
          .toList(),
    );
  }
}

class DistrictModel {
  final int id;
  final int stateId;
  final String districtCode;
  final String districtName;
  final String contactPerson;
  final String contactPhone;
  final String contactEmail;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  DistrictModel({
    required this.id,
    required this.stateId,
    required this.districtCode,
    required this.districtName,
    required this.contactPerson,
    required this.contactPhone,
    required this.contactEmail,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      stateId: json['state_id'],
      districtCode: json['district_code'] ?? "",
      districtName: json['district_name'] ?? "",
      contactPerson: json['contact_person'] ?? "",
      contactPhone: json['contact_phone'] ?? "",
      contactEmail: json['contact_email'] ?? "",
      status: json['status'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}