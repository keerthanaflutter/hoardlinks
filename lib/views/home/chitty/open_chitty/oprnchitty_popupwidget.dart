import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chitty_join_provider.dart';
import 'package:hoardlinks/viewmodels/chittydetails_provider.dart';
import 'package:provider/provider.dart';

class ChittyDetailsPopup extends StatelessWidget {
  const ChittyDetailsPopup({super.key});

  static const primaryColor = Color(0xFFB11226);

  @override
  Widget build(BuildContext context) {
    // Watching the details provider for the UI data
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
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Chitty Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
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

    // We use StatefulBuilder to manage the 'numberOfReq' locally in the popup
    int localReqCount = 1;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        // Access the Join Provider
        final joinProvider = context.watch<ChittyJoinProvider>();

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
              child: _infoRow(Icons.group, "Joined Members", "0 / ${chitty.totalMembers}"),
            ),

            if (member != null)
              _sectionCard(
                "Your Membership",
                child: Column(
                  children: [
                    _infoRow(Icons.person, "Member No", member.memberNo.toString()),
                    _infoRow(Icons.verified, "Join Status", member.joinStatus),
                    _infoRow(Icons.date_range, "Join Date", member.joinDate.toIso8601String().split('T').first),
                  ],
                ),
              ),

            // --- JOIN SECTION WITH COUNTER ---
            if (isOpen && member == null) ...[
              const SizedBox(height: 10),
              const Center(
                child: Text("Select Number of Requests", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              const SizedBox(height: 10),
              
              // Increment/Decrement Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _countButton(Icons.remove, () {
                    if (localReqCount > 1) setLocalState(() => localReqCount--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text("$localReqCount", 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  _countButton(Icons.add, () {
                    if (localReqCount < (chitty.totalMembers)) setLocalState(() => localReqCount++);
                  }),
                ],
              ),
              
              const SizedBox(height: 24),

              // Join Button
              InkWell(
                onTap: joinProvider.isLoading ? null : () async {
                  await context.read<ChittyJoinProvider>().joinChitty(
                    chittyId: chitty.id,
                    remarks: "Joining via App",
                    numberOfReq: localReqCount,
                  );

                  if (context.mounted) {
                    final error = context.read<ChittyJoinProvider>().errorMessage;
                    final response = context.read<ChittyJoinProvider>().responseData;

                    if (error == null) {
                      Navigator.pop(context); // Close Popup
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response?['message'] ?? "Joined Successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: joinProvider.isLoading 
                        ? [Colors.grey, Colors.grey] 
                        : [Colors.green, const Color(0xFF2E7D32)],
                    ),
                  ),
                  child: Center(
                    child: joinProvider.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Join Chitty", 
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // Helper for Counter Buttons
  Widget _countButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primaryColor, width: 2),
        ),
        child: Icon(icon, color: primaryColor),
      ),
    );
  }

  // --- UI Components below remain the same as your original ---

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
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
        const SizedBox(height: 6),
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
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}