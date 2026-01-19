import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chitty_join_provider.dart';
import 'package:hoardlinks/viewmodels/chittydetails_provider.dart';
import 'package:provider/provider.dart';


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
    // FIX: Check if chittyMember is a List. If it is, take the first element.
    // This prevents the "List is not a subtype of Map" error.
    dynamic memberData = json['chittyMember'];
    ChittyMember? parsedMember;

    if (memberData != null) {
      if (memberData is List && memberData.isNotEmpty) {
        parsedMember = ChittyMember.fromJson(memberData[0]);
      } else if (memberData is Map<String, dynamic>) {
        parsedMember = ChittyMember.fromJson(memberData);
      }
    }

    return ChittyDetailsModel(
      message: json['message'] ?? "",
      chitty: Chitty.fromJson(json['chitty']),
      chittyMember: parsedMember,
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
  final DateTime lotTime;

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
    required this.lotTime,
  });

  factory Chitty.fromJson(Map<String, dynamic> json) {
    return Chitty(
      id: json['id'],
      schemeCode: json['scheme_code'] ?? '',
      schemeName: json['scheme_name'] ?? '',
      frequency: json['frequency'] ?? '',
      level: json['level'] ?? '',
      stateId: json['state_id'],
      districtId: json['district_id'],
      monthlyAmount: json['monthly_amount']?.toString() ?? '0',
      amount: json['amount']?.toString() ?? '0',
      totalMembers: json['total_members'] ?? 0,
      durationMonths: json['duration_months'] ?? 0,
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      lotMethod: json['lot_method'] ?? '',
      status: json['status'] ?? '',
      lotTime: DateTime.parse(json['lot_time']),
    );
  }
}

class ChittyMember {
  final int id;
  final int chittyId;
  final int memberNo;
  final String joinStatus;
  final DateTime joinDate;
  final String remarks;

  ChittyMember({
    required this.id,
    required this.chittyId,
    required this.memberNo,
    required this.joinStatus,
    required this.joinDate,
    required this.remarks,
  });

  factory ChittyMember.fromJson(Map<String, dynamic> json) {
    return ChittyMember(
      id: json['id'],
      chittyId: json['chitty_id'],
      memberNo: json['member_no'] ?? 0,
      joinStatus: json['join_status'] ?? '',
      joinDate: json['join_date'] != null 
          ? DateTime.parse(json['join_date']) 
          : DateTime.now(),
      remarks: json['remarks'] ?? '',
    );
  }
}

class ChittyCycle {
  final int id;
  final int chittyId;
  final int cycleNo;
  final DateTime cycleStartDate;
  final String status;

  ChittyCycle({
    required this.id,
    required this.chittyId,
    required this.cycleNo,
    required this.cycleStartDate,
    required this.status,
  });

  factory ChittyCycle.fromJson(Map<String, dynamic> json) {
    return ChittyCycle(
      id: json['id'],
      chittyId: json['chitty_id'],
      cycleNo: json['cycle_no'],
      cycleStartDate: DateTime.parse(json['cycle_start_date']),
      status: json['status'],
    );
  }
}

// --- UI CODE ---

class ChittyDetailsPopup extends StatelessWidget {
  const ChittyDetailsPopup({super.key});

  static const primaryColor = Color(0xFFB11226);

  @override
  Widget build(BuildContext context) {
    final detailsProvider = context.watch<ChittyDetailsProvider>();

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 50, height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Chitty Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildBody(context, detailsProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChittyDetailsProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return Center(child: Text(provider.error!, style: const TextStyle(color: Colors.red)));
    if (provider.chittyDetails == null) return const Center(child: Text("No data found"));

    final details = provider.chittyDetails!;
    final chitty = details.chitty;
    final member = details.chittyMember;
    final isOpen = chitty.status.toUpperCase() == "OPEN";

    final int monthlyAmount = int.tryParse(chitty.monthlyAmount) ?? 0;
    final int totalAmount = int.tryParse(chitty.amount) ?? 0;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        final joinProvider = context.watch<ChittyJoinProvider>();
        // Using a static/local variable for counter
        int localReqCount = 1; 

        return ListView(
          children: [
            _sectionCard(
              "Scheme Overview",
              child: Column(
                children: [
                  _infoRow(Icons.card_giftcard, "Scheme Name", chitty.schemeName),
                  _infoRow(Icons.qr_code, "Scheme Code", chitty.schemeCode),
                  _infoRow(Icons.schedule, "Frequency", chitty.frequency),
                  _infoRow(Icons.calendar_month, "Duration", "${chitty.durationMonths} months"),
                ],
              ),
            ),
            _amountCard(monthly: monthlyAmount, total: totalAmount),
            _sectionCard(
              "Members",
              child: _infoRow(Icons.group, "Total Capacity", "${chitty.totalMembers} Members"),
            ),
            if (member != null)
              _sectionCard(
                "Your Membership",
                child: Column(
                  children: [
                    _infoRow(Icons.person, "Member No", member.memberNo.toString()),
                    _infoRow(Icons.verified, "Join Status", member.joinStatus),
                    _infoRow(Icons.date_range, "Join Date", member.joinDate.toString().split(' ').first),
                  ],
                ),
              ),
            if (isOpen && member == null) ...[
              const SizedBox(height: 10),
              const Center(child: Text("Select Number of Slots", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _countButton(Icons.remove, () => setLocalState(() { if (localReqCount > 1) localReqCount--; })),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text("$localReqCount", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  _countButton(Icons.add, () => setLocalState(() { if (localReqCount < chitty.totalMembers) localReqCount++; })),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: joinProvider.isLoading ? null : () async {
                  await context.read<ChittyJoinProvider>().joinChitty(
                    chittyId: chitty.id,
                    remarks: "Joining via App",
                    numberOfReq: localReqCount,
                  );
                  if (context.mounted) {
                    final error = context.read<ChittyJoinProvider>().errorMessage;
                    if (error == null) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Joined Successfully!"), backgroundColor: Colors.green));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: joinProvider.isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Join Chitty", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ],
          ],
        );
      },
    );
  }

  // --- UI Helpers ---

  Widget _countButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: primaryColor),
      style: IconButton.styleFrom(side: const BorderSide(color: primaryColor, width: 2)),
    );
  }

  Widget _sectionCard(String title, {required Widget child}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }

  Widget _amountCard({required int monthly, required int total}) {
    return Card(
      color: primaryColor.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _amountTile("Monthly", monthly),
            _amountTile("Total", total),
          ],
        ),
      ),
    );
  }

  Widget _amountTile(String label, int amount) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
        Text("₹$amount", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(value),
        ],
      ),
    );
  }
}