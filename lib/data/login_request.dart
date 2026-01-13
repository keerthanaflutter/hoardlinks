class LoginResponseModel {
  final bool success;
  final String message;
  final String accessToken;
  final String roleType;
  final UserModel user;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.roleType,
    required this.user,
  });

  // Factory method to create an instance from a JSON response
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      message: json['message'],
      accessToken: json['access_token'],
      roleType: json['role_type'],
      user: UserModel.fromJson(json['user']),
    );
  }
}


class UserModel {
  final int id;
  final String loginId;
  final String passwordHash;
  final String mobileNumber;
  final String roleType;
  final int stateId;  // This is the stateId from the response
  final int districtId;  // This is the districtId from the response
  final int agencyId;
  final String firebaseUserKey;
  final String fcmToken;
  final String deviceId;
  final String deviceType;
  final bool isActive;
  final String? lastLoginAt;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.loginId,
    required this.passwordHash,
    required this.mobileNumber,
    required this.roleType,
    required this.stateId,
    required this.districtId,
    required this.agencyId,
    required this.firebaseUserKey,
    required this.fcmToken,
    required this.deviceId,
    required this.deviceType,
    required this.isActive,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from a JSON response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      loginId: json['login_id'],
      passwordHash: json['password_hash'],
      mobileNumber: json['mobile_number'],
      roleType: json['role_type'],
      stateId: json['state_id'],  // Map the state_id field from the response
      districtId: json['district_id'],  // Map the district_id field from the response
      agencyId: json['agency_id'],
      firebaseUserKey: json['firebaseUserKey'],
      fcmToken: json['FCM_token'],
      deviceId: json['device_id'],
      deviceType: json['deviceType'],
      isActive: json['is_active'],
      lastLoginAt: json['last_login_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
