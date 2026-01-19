

// /// -------- ROOT RESPONSE MODEL --------
// class ChittyResponseModel {
//   final String message;
//   final List<ChittyScheme> open;
//   final List<ChittyScheme> running;
//   final List<ChittyScheme> closed;

//   ChittyResponseModel({
//     required this.message,
//     required this.open,
//     required this.running,
//     required this.closed,
//   });

//   factory ChittyResponseModel.fromJson(Map<String, dynamic> json) {
//     return ChittyResponseModel(
//       message: json['message'] ?? '',
//       open: (json['open'] as List<dynamic>? ?? [])
//           .map((e) => ChittyScheme.fromJson(e))
//           .toList(),
//       running: (json['running'] as List<dynamic>? ?? [])
//           .map((e) => ChittyScheme.fromJson(e))
//           .toList(),
//       closed: (json['closed'] as List<dynamic>? ?? [])
//           .map((e) => ChittyScheme.fromJson(e))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'open': open.map((e) => e.toJson()).toList(),
//       'running': running.map((e) => e.toJson()).toList(),
//       'closed': closed.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// /// -------- CHITTY SCHEME MODEL --------
// class ChittyScheme {
//   final int id;
//   final String schemeCode;
//   final String schemeName;
//   final String frequency;
//   final String level;
//   final int stateId;
//   final int? districtId;
//   final String monthlyAmount;
//   final String amount;
//   final int totalMembers;
//   final int durationMonths;
//   final DateTime startDate;
//   final DateTime endDate;
//   final String lotMethod;
//   final String status;
//   final int createdByUser;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime lotTime;  // Added field for lot_time
//   final ChittySchemeCount count;

//   ChittyScheme({
//     required this.id,
//     required this.schemeCode,
//     required this.schemeName,
//     required this.frequency,
//     required this.level,
//     required this.stateId,
//     this.districtId,
//     required this.monthlyAmount,
//     required this.amount,
//     required this.totalMembers,
//     required this.durationMonths,
//     required this.startDate,
//     required this.endDate,
//     required this.lotMethod,
//     required this.status,
//     required this.createdByUser,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.lotTime,  // Include in constructor
//     required this.count,
//   });

//   factory ChittyScheme.fromJson(Map<String, dynamic> json) {
//     return ChittyScheme(
//       id: json['id'],
//       schemeCode: json['scheme_code'],
//       schemeName: json['scheme_name'],
//       frequency: json['frequency'],
//       level: json['level'],
//       stateId: json['state_id'],
//       districtId: json['district_id'],
//       monthlyAmount: json['monthly_amount'],
//       amount: json['amount'],
//       totalMembers: json['total_members'],
//       durationMonths: json['duration_months'],
//       startDate: DateTime.parse(json['start_date']),
//       endDate: DateTime.parse(json['end_date']),
//       lotMethod: json['lot_method'],
//       status: json['status'],
//       createdByUser: json['created_by_user'],
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['updated_at']),
//       lotTime: DateTime.parse(json['lot_time']),  // Parse lot_time
//       count: ChittySchemeCount.fromJson(json['_count'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'scheme_code': schemeCode,
//       'scheme_name': schemeName,
//       'frequency': frequency,
//       'level': level,
//       'state_id': stateId,
//       'district_id': districtId,
//       'monthly_amount': monthlyAmount,
//       'amount': amount,
//       'total_members': totalMembers,
//       'duration_months': durationMonths,
//       'start_date': startDate.toIso8601String(),
//       'end_date': endDate.toIso8601String(),
//       'lot_method': lotMethod,
//       'status': status,
//       'created_by_user': createdByUser,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//       'lot_time': lotTime.toIso8601String(),  // Convert lot_time to ISO string
//       '_count': count.toJson(),
//     };
//   }
// }

// /// -------- CHITTY SCHEME COUNT MODEL --------
// class ChittySchemeCount {
//   final int chittyMember;

//   ChittySchemeCount({
//     required this.chittyMember,
//   });

//   factory ChittySchemeCount.fromJson(Map<String, dynamic> json) {
//     return ChittySchemeCount(
//       chittyMember: json['chitty_member'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'chitty_member': chittyMember,
//     };
//   }
// }


/// -------- ROOT RESPONSE MODEL --------
class ChittyResponseModel {
  final String message;
  final List<ChittyScheme> open;
  final List<ChittyScheme> running;
  final List<ChittyScheme> closed;
  final int? agency; // Added this field based on your JSON

  ChittyResponseModel({
    required this.message,
    required this.open,
    required this.running,
    required this.closed,
    this.agency,
  });

  factory ChittyResponseModel.fromJson(Map<String, dynamic> json) {
    return ChittyResponseModel(
      message: json['message'] ?? '',
      agency: json['agency'],
      open: (json['open'] as List?)
              ?.map((e) => ChittyScheme.fromJson(e))
              .toList() ?? [],
      running: (json['running'] as List?)
              ?.map((e) => ChittyScheme.fromJson(e))
              .toList() ?? [],
      closed: (json['closed'] as List?)
              ?.map((e) => ChittyScheme.fromJson(e))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'agency': agency,
      'open': open.map((e) => e.toJson()).toList(),
      'running': running.map((e) => e.toJson()).toList(),
      'closed': closed.map((e) => e.toJson()).toList(),
    };
  }
}

/// -------- CHITTY SCHEME MODEL --------
class ChittyScheme {
  final int id;
  final String schemeCode;
  final String schemeName;
  final String frequency;
  final String level;
  final int? stateId;      // Changed to int? because JSON shows null
  final int? districtId;   // Already nullable
  final String monthlyAmount;
  final String amount;
  final int totalMembers;
  final int durationMonths;
  final DateTime startDate;
  final DateTime endDate;
  final String lotMethod;
  final String status;
  final int createdByUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lotTime;
  final ChittySchemeCount count;

  ChittyScheme({
    required this.id,
    required this.schemeCode,
    required this.schemeName,
    required this.frequency,
    required this.level,
    this.stateId,
    this.districtId,
    required this.monthlyAmount,
    required this.amount,
    required this.totalMembers,
    required this.durationMonths,
    required this.startDate,
    required this.endDate,
    required this.lotMethod,
    required this.status,
    required this.createdByUser,
    required this.createdAt,
    required this.updatedAt,
    required this.lotTime,
    required this.count,
  });

  factory ChittyScheme.fromJson(Map<String, dynamic> json) {
    return ChittyScheme(
      id: json['id'] ?? 0,
      schemeCode: json['scheme_code'] ?? '',
      schemeName: json['scheme_name'] ?? '',
      frequency: json['frequency'] ?? '',
      level: json['level'] ?? '',
      stateId: json['state_id'], // Now handles null correctly
      districtId: json['district_id'],
      monthlyAmount: json['monthly_amount']?.toString() ?? '0',
      amount: json['amount']?.toString() ?? '0',
      totalMembers: json['total_members'] ?? 0,
      durationMonths: json['duration_months'] ?? 0,
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toIso8601String()),
      lotMethod: json['lot_method'] ?? '',
      status: json['status'] ?? '',
      createdByUser: json['created_by_user'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      lotTime: DateTime.parse(json['lot_time'] ?? DateTime.now().toIso8601String()),
      count: ChittySchemeCount.fromJson(json['_count'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheme_code': schemeCode,
      'scheme_name': schemeName,
      'frequency': frequency,
      'level': level,
      'state_id': stateId,
      'district_id': districtId,
      'monthly_amount': monthlyAmount,
      'amount': amount,
      'total_members': totalMembers,
      'duration_months': durationMonths,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'lot_method': lotMethod,
      'status': status,
      'created_by_user': createdByUser,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'lot_time': lotTime.toIso8601String(),
      '_count': count.toJson(),
    };
  }
}

/// -------- CHITTY SCHEME COUNT MODEL --------
class ChittySchemeCount {
  final int chittyMember;

  ChittySchemeCount({
    required this.chittyMember,
  });

  factory ChittySchemeCount.fromJson(Map<String, dynamic> json) {
    return ChittySchemeCount(
      chittyMember: json['chitty_member'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chitty_member': chittyMember,
    };
  }
}