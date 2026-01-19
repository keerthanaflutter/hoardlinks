class AgencyDetailModel {
  final String? message;
  final AgencyData? data;

  AgencyDetailModel({this.message, this.data});

  factory AgencyDetailModel.fromJson(Map<String, dynamic> json) {
    return AgencyDetailModel(
      message: json['message'],
      data: json['data'] != null ? AgencyData.fromJson(json['data']) : null,
    );
  }
}

class AgencyData {
  final int? id;
  final int? districtId;
  final String? agencyCode;
  final String? legalName;
  final String? tradeName;
  final String? contactPerson;
  final String? contactPhone;
  final String? contactEmail;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? pincode;
  final String? gstNumber;
  final String? membershipStatus;
  final String? membershipStartDt;
  final String? membershipEndDt;

  AgencyData({
    this.id,
    this.districtId,
    this.agencyCode,
    this.legalName,
    this.tradeName,
    this.contactPerson,
    this.contactPhone,
    this.contactEmail,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.pincode,
    this.gstNumber,
    this.membershipStatus,
    this.membershipStartDt,
    this.membershipEndDt,
  });

  factory AgencyData.fromJson(Map<String, dynamic> json) {
    return AgencyData(
      id: json['id'],
      districtId: json['district_id'],
      agencyCode: json['agency_code'],
      legalName: json['legal_name'],
      tradeName: json['trade_name'],
      contactPerson: json['contact_person'],
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      addressLine1: json['address_line1'],
      addressLine2: json['address_line2'],
      city: json['city'],
      pincode: json['pincode'],
      gstNumber: json['gst_number'],
      membershipStatus: json['membership_status'],
      membershipStartDt: json['membership_start_dt'],
      membershipEndDt: json['membership_end_dt'],
    );
  }
}