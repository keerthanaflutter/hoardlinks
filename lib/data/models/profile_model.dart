/// Top-level response model
class ProfileResponse {
  final String message;
  final ProfileData data;

  ProfileResponse({
    required this.message,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'] ?? '',
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Profile main data model
class ProfileData {
  final int id;
  final String loginId;
  final String mobileNumber;
  final String roleType;
  final int? stateId;
  final int? districtId;
  final int? agencyId;
  final bool isActive;
  final String? lastLoginAt;
  final String createdAt;
  final String updatedAt;
  final String? stateCommittee;
  final String? districtCommittee;
  final AgencyMember? agencyMember;

  ProfileData({
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
    this.stateCommittee,
    this.districtCommittee,
    this.agencyMember,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] ?? 0,
      loginId: json['login_id'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      roleType: json['role_type'] ?? '',
      stateId: json['state_id'],
      districtId: json['district_id'],
      agencyId: json['agency_id'],
      isActive: json['is_active'] ?? false,
      lastLoginAt: json['last_login_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      stateCommittee: json['state_committee'],
      districtCommittee: json['district_committee'],
      agencyMember: json['agency_member'] != null
          ? AgencyMember.fromJson(json['agency_member'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login_id': loginId,
      'mobile_number': mobileNumber,
      'role_type': roleType,
      'state_id': stateId,
      'district_id': districtId,
      'agency_id': agencyId,
      'is_active': isActive,
      'last_login_at': lastLoginAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'state_committee': stateCommittee,
      'district_committee': districtCommittee,
      'agency_member': agencyMember?.toJson(),
    };
  }
}

/// Agency member model
class AgencyMember {
  final int id;
  final String legalName;
  final String tradeName;

  AgencyMember({
    required this.id,
    required this.legalName,
    required this.tradeName,
  });

  factory AgencyMember.fromJson(Map<String, dynamic> json) {
    return AgencyMember(
      id: json['id'] ?? 0,
      legalName: json['legal_name'] ?? '',
      tradeName: json['trade_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'legal_name': legalName,
      'trade_name': tradeName,
    };
  }
}
