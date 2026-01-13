

// class ChittyDetailsModel {
//   final String message;
//   final Chitty chitty;
//   final ChittyMember? chittyMember;
//   final List<ChittyCycle>? chittyCycle;

//   ChittyDetailsModel({
//     required this.message,
//     required this.chitty,
//     this.chittyMember,
//     this.chittyCycle,
//   });

//   factory ChittyDetailsModel.fromJson(Map<String, dynamic> json) {
//     return ChittyDetailsModel(
//       message: json['message'],
//       chitty: Chitty.fromJson(json['chitty']),
//       chittyMember: json['chittyMember'] != null
//           ? ChittyMember.fromJson(json['chittyMember'])
//           : null,

//       /// ✅ PARSE chittyCycle SAFELY
//       chittyCycle: (json['chittyCycle'] as List<dynamic>?)
//           ?.map((e) => ChittyCycle.fromJson(e))
//           .toList(),
//     );
//   }
// }


// class Chitty {
//   final int id;
//   final String schemeCode;
//   final String schemeName;
//   final String frequency;
//   final String level;
//   final int? stateId;
//   final int? districtId;
//   final String monthlyAmount;
//   final String amount;
//   final int totalMembers;
//   final int durationMonths;
//   final DateTime startDate;
//   final DateTime endDate;
//   final String lotMethod;
//   final String status;

//   Chitty({
//     required this.id,
//     required this.schemeCode,
//     required this.schemeName,
//     required this.frequency,
//     required this.level,
//     this.stateId,
//     this.districtId,
//     required this.monthlyAmount,
//     required this.amount,
//     required this.totalMembers,
//     required this.durationMonths,
//     required this.startDate,
//     required this.endDate,
//     required this.lotMethod,
//     required this.status,
//   });

//   factory Chitty.fromJson(Map<String, dynamic> json) {
//     return Chitty(
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
//     );
//   }
// }
// class ChittyMember {
//   final int id;
//   final int chittyId;
//   final int memberNo;
//   final String joinStatus;
//   final DateTime joinDate;
//   final String remarks;
//   final List<ChittyCycle> cycles;

//   ChittyMember({
//     required this.id,
//     required this.chittyId,
//     required this.memberNo,
//     required this.joinStatus,
//     required this.joinDate,
//     required this.remarks,
//     required this.cycles,
//   });

//   factory ChittyMember.fromJson(Map<String, dynamic> json) {
//     return ChittyMember(
//       id: json['id'],
//       chittyId: json['chitty_id'],
//       memberNo: json['member_no'],
//       joinStatus: json['join_status'],
//       joinDate: DateTime.parse(json['join_date']),
//       remarks: json['remarks'] ?? '',
//       cycles: (json['chitty_cycle'] as List<dynamic>? ?? [])
//           .map((e) => ChittyCycle.fromJson(e))
//           .toList(),
//     );
//   }
// }

// class ChittyCycle {
//   final int id;
//   final int chittyId;
//   final int cycleNo;
//   final DateTime cycleStartDate;
//   final DateTime dueDate;
//   final DateTime paymentLockDate;
//   final String status;

//   ChittyCycle({
//     required this.id,
//     required this.chittyId,
//     required this.cycleNo,
//     required this.cycleStartDate,
//     required this.dueDate,
//     required this.paymentLockDate,
//     required this.status,
//   });

//   factory ChittyCycle.fromJson(Map<String, dynamic> json) {
//     return ChittyCycle(
//       id: json['id'],
//       chittyId: json['chitty_id'],
//       cycleNo: json['cycle_no'],
//       cycleStartDate: DateTime.parse(json['cycle_start_date']),
//       dueDate: DateTime.parse(json['due_date']),
//       paymentLockDate: DateTime.parse(json['payment_lock_date']),
//       status: json['status'],
//     );
//   }
// }
import 'dart:convert';

class ChittyDetailsModel {
  final String message;
  final Chitty chitty;
  final ChittyMember? chittyMember;
  final List<ChittyCycle>? chittyCycle;

  ChittyDetailsModel({
    required this.message,
    required this.chitty,
    this.chittyMember,
    this.chittyCycle,
  });

  factory ChittyDetailsModel.fromJson(Map<String, dynamic> json) {
    return ChittyDetailsModel(
      message: json['message'],
      chitty: Chitty.fromJson(json['chitty']),
      chittyMember: json['chittyMember'] != null
          ? ChittyMember.fromJson(json['chittyMember'])
          : null,
      chittyCycle: (json['chittyCycle'] as List<dynamic>?)
          ?.map((e) => ChittyCycle.fromJson(e))
          .toList(),
    );
  }
}

class Chitty {
  final int id;
  final String schemeCode;
  final String schemeName;
  final String frequency;
  final String level;
  final int? stateId;
  final int? districtId;
  final String monthlyAmount;
  final String amount;
  final int totalMembers;
  final int durationMonths;
  final DateTime startDate;
  final DateTime endDate;
  final String lotMethod;
  final String status;
  final DateTime lotTime; // Added field for lot_time

  Chitty({
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
    required this.lotTime, // Include in constructor
  });

  factory Chitty.fromJson(Map<String, dynamic> json) {
    return Chitty(
      id: json['id'],
      schemeCode: json['scheme_code'],
      schemeName: json['scheme_name'],
      frequency: json['frequency'],
      level: json['level'],
      stateId: json['state_id'],
      districtId: json['district_id'],
      monthlyAmount: json['monthly_amount'],
      amount: json['amount'],
      totalMembers: json['total_members'],
      durationMonths: json['duration_months'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      lotMethod: json['lot_method'],
      status: json['status'],
      lotTime: DateTime.parse(json['lot_time']), // Parse lot_time
    );
  }
}

class ChittyMember {
  final int id;
  final int chittyId;
  final int memberNo;
  final String joinStatus;
  final DateTime joinDate;
  final DateTime exitDate; // Added exit_date field
  final String remarks;
  final List<ChittyCycle> cycles;

  ChittyMember({
    required this.id,
    required this.chittyId,
    required this.memberNo,
    required this.joinStatus,
    required this.joinDate,
    required this.exitDate, // Added exit_date in constructor
    required this.remarks,
    required this.cycles,
  });

  factory ChittyMember.fromJson(Map<String, dynamic> json) {
    return ChittyMember(
      id: json['id'],
      chittyId: json['chitty_id'],
      memberNo: json['member_no'],
      joinStatus: json['join_status'],
      joinDate: DateTime.parse(json['join_date']),
      exitDate: DateTime.parse(json['exit_date']), // Parse exit_date
      remarks: json['remarks'] ?? '',
      cycles: (json['chitty_cycle'] as List<dynamic>? ?? [])
          .map((e) => ChittyCycle.fromJson(e))
          .toList(),
    );
  }
}

class ChittyCycle {
  final int id;
  final int chittyId;
  final int cycleNo;
  final DateTime cycleStartDate;
  final DateTime dueDate;
  final DateTime paymentLockDate;
  final String status;
  final int? winnerMemberId;

  ChittyCycle({
    required this.id,
    required this.chittyId,
    required this.cycleNo,
    required this.cycleStartDate,
    required this.dueDate,
    required this.paymentLockDate,
    required this.status,
    this.winnerMemberId,
  });

  factory ChittyCycle.fromJson(Map<String, dynamic> json) {
    return ChittyCycle(
      id: json['id'],
      chittyId: json['chitty_id'],
      cycleNo: json['cycle_no'],
      cycleStartDate: DateTime.parse(json['cycle_start_date']),
      dueDate: DateTime.parse(json['due_date']),
      paymentLockDate: DateTime.parse(json['payment_lock_date']),
      status: json['status'],
      winnerMemberId: json['winner_member_id'], // Parse winner_member_id
    );
  }
  
}
