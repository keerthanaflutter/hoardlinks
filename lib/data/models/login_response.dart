class UserModel {
  final int id;
  final String loginId;
  final String mobileNumber;
  final String roleType;

  final int? stateId;
  final int? districtId;
  final int? agencyId;

  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.loginId,
    required this.mobileNumber,
    required this.roleType,
    this.stateId,
    this.districtId,
    this.agencyId,
    required this.isActive,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      loginId: json['login_id'],
      mobileNumber: json['mobile_number'] ?? '',
      roleType: json['role_type'],

      stateId: json['state_id'],
      districtId: json['district_id'],
      agencyId: json['agency_id'],

      isActive: json['is_active'] ?? false,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
