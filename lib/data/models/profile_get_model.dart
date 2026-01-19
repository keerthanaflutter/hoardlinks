import 'dart:convert';

class Profile {
  final int id;
  final String loginId;
  final String mobileNumber;
  final String roleType;
  final int stateId;
  final int districtId;
  final int agencyId;
  final bool isActive;
  final String? lastLoginAt;
  final String createdAt;
  final String updatedAt;
  final StateCommittee stateCommittee;
  final DistrictCommittee districtCommittee;
  final AgencyMember agencyMember;

  Profile({
    required this.id,
    required this.loginId,
    required this.mobileNumber,
    required this.roleType,
    required this.stateId,
    required this.districtId,
    required this.agencyId,
    required this.isActive,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    required this.stateCommittee,
    required this.districtCommittee,
    required this.agencyMember,
  });

  // From JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      loginId: json['login_id'],
      mobileNumber: json['mobile_number'],
      roleType: json['role_type'],
      stateId: json['state_id'],
      districtId: json['district_id'],
      agencyId: json['agency_id'],
      isActive: json['is_active'],
      lastLoginAt: json['last_login_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      stateCommittee: StateCommittee.fromJson(json['state_committee']),
      districtCommittee: DistrictCommittee.fromJson(json['district_committee']),
      agencyMember: AgencyMember.fromJson(json['agency_member']),
    );
  }

  // To JSON
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
      'state_committee': stateCommittee.toJson(),
      'district_committee': districtCommittee.toJson(),
      'agency_member': agencyMember.toJson(),
    };
  }
}

class StateCommittee {
  final int id;
  final String stateName;
  final String stateCode;

  StateCommittee({
    required this.id,
    required this.stateName,
    required this.stateCode,
  });

  factory StateCommittee.fromJson(Map<String, dynamic> json) {
    return StateCommittee(
      id: json['id'],
      stateName: json['state_name'],
      stateCode: json['state_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_name': stateName,
      'state_code': stateCode,
    };
  }
}

class DistrictCommittee {
  final int id;
  final String districtName;

  DistrictCommittee({
    required this.id,
    required this.districtName,
  });

  factory DistrictCommittee.fromJson(Map<String, dynamic> json) {
    return DistrictCommittee(
      id: json['id'],
      districtName: json['district_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district_name': districtName,
    };
  }
}

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
      id: json['id'],
      legalName: json['legal_name'],
      tradeName: json['trade_name'],
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
