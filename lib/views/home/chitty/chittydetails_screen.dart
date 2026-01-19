import 'package:flutter/material.dart';
import 'package:hoardlinks/data/models/chittydetails_model.dart';
import 'package:hoardlinks/viewmodels/aution_provider.dart';
import 'package:hoardlinks/viewmodels/chitttybig_provider.dart';
import 'package:hoardlinks/viewmodels/chittydetails_provider.dart';
import 'package:hoardlinks/views/home/chitty/runningchitty/runningchitty_bid_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';


class ChittyDetailsScreen extends StatefulWidget {
  final int chittyId;

  const ChittyDetailsScreen({super.key, required this.chittyId});

  @override
  State<ChittyDetailsScreen> createState() => _ChittyDetailsScreenState();
}

class _ChittyDetailsScreenState extends State<ChittyDetailsScreen> {
  static const primaryColor = Color(0xFFB11226);
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _isLotTimeReached = false;
  final TextEditingController _bidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChittyDetailsProvider>().fetchChittyDetails(widget.chittyId);
    });
    _startTimer();
  }

  void _calculateTime() {
    final provider = context.read<ChittyDetailsProvider>();
    if (provider.chittyDetails == null) return;

    final lotTimeRaw = provider.chittyDetails!.chitty.lotTime;
    final now = DateTime.now();
    DateTime parsed = lotTimeRaw is DateTime
        ? lotTimeRaw
        : DateTime.parse(lotTimeRaw.toString());
    DateTime targetTime;

    if (parsed.year == 1970) {
      targetTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsed.hour,
        parsed.minute,
        parsed.second,
      );
      if (targetTime.isBefore(now))
        targetTime = targetTime.add(const Duration(days: 1));
    } else {
      targetTime = parsed;
    }

    final difference = targetTime.difference(now);
    if (mounted) {
      setState(() {
        if (difference.isNegative || difference.inSeconds <= 0) {
          _remainingTime = Duration.zero;
          _isLotTimeReached = true;
          _timer?.cancel();
        } else {
          _remainingTime = difference;
          _isLotTimeReached = false;
        }
      });
    }
  }

  void _startTimer() {
    _calculateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _calculateTime(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChittyDetailsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Chitty Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(ChittyDetailsProvider provider) {
    if (provider.isLoading)
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    if (provider.error != null)
      return Center(
        child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
      );
    if (provider.chittyDetails == null)
      return const Center(child: Text("No data found"));

    final details = provider.chittyDetails!;
    final chitty = details.chitty;
    final cycles = details.chittyCycle ?? [];
    final int joinedMembers = details.chittyMember != null ? 1 : 0;
    final double progress = chitty.totalMembers == 0
        ? 0.0
        : joinedMembers / chitty.totalMembers;

    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');
    final String lotTimeText = _isLotTimeReached
        ? "Lot Time Reached"
        : "$hours:$minutes:$seconds";

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        /// 📅 DYNAMIC COUNTDOWN CARD
        Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.08), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "Lot Time Countdown",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lotTimeText,
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: _isLotTimeReached ? Colors.green : primaryColor,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        ),

        _sectionCard(
          title: "Scheme Overview",
          children: [
            _iconRow(Icons.card_membership, "Scheme Name", chitty.schemeName),
            _iconRow(Icons.qr_code, "Scheme Code", chitty.schemeCode),
            _iconRow(Icons.schedule, "Frequency", chitty.frequency),
            _iconRow(
              Icons.timelapse,
              "Duration",
              "${chitty.durationMonths} months",
            ),
          ],
        ),

        _membersProgressCard(
          joined: joinedMembers,
          total: chitty.totalMembers,
          progress: progress,
        ),
        _amountCard(monthly: chitty.monthlyAmount, total: chitty.amount),

        if (cycles.isNotEmpty)
          _sectionCard(
            title: "Chitty Cycles",
            children: cycles.map<Widget>((cycle) {
              return _cycleCard(cycle, details.chitty, details.chittyMember);
            }).toList(),
          ),
      
      ],
    );
  }

  Widget _membersProgressCard({
    required int joined,
    required int total,
    required double progress,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Members Status",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$joined / $total Joined",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}% Full",
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _amountCard({required String monthly, required String total}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _amountTile("Monthly Pay", monthly),
            Container(width: 1, height: 40, color: Colors.grey.shade300),
            _amountTile("Total Fund", total),
          ],
        ),
      ),
    );
  }

  Widget _amountTile(String label, String amount) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Text(
          "₹$amount",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _iconRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }


  // Updated Status Color helper to include 'Open'
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        return Colors.green;
      case 'open':
        return primaryColor; // Blue for active/open bidding
      case 'pending':
      case 'ongoing':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }


Widget _cycleCard(ChittyCycle cycle, Chitty chitty, ChittyMember? member) {
  bool isOpen = cycle.status.toLowerCase() == 'open';

  final String chittyId = chitty.id.toString();
  final String cycleId = cycle.id.toString();
  final String memberId = member?.id.toString() ?? "N/A";
  final String duration = "${chitty.durationMonths} Months";

  // Formatting the date to a readable string (e.g., 14-01-2026)
  final String chittyDate = "${chitty.startDate.day.toString().padLeft(2, '0')}-${chitty.startDate.month.toString().padLeft(2, '0')}-${chitty.startDate.year}";

  return Container(
    margin: const EdgeInsets.only(bottom: 12, left: 4, right: 4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      leading: Container(
        width: 50, // Adjust size if needed
        height: 50,
        decoration: BoxDecoration(
          color: _statusColor(cycle.status).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.attach_money, // Use an appropriate icon for amount
            color: _statusColor(cycle.status),
            size: 24,
          ),
        ),
      ),
      title: Text(
        "₹${chitty.amount}",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chitty Date: $chittyDate",
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
         
        ],
      ),
      trailing: isOpen
          ? ElevatedButton(
              onPressed: () async {
                context.read<ChittyBidProvider>().resetState();

                await context.read<AuctionIdProvider>().fetchAuctionBid(
                      int.parse(chittyId),
                      int.parse(cycleId),
                    );

                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => BidPopupBottomSheet(
                    chitty: chitty,
                    cycle: cycle,
                    memberNo: memberId,
                    duration: duration,
                  ),
                );

                if (mounted && context.read<ChittyBidProvider>().isBidSuccessful) {
                  debugPrint("Bid successful, rebuilding details screen...");
                  context.read<ChittyDetailsProvider>().fetchChittyDetails(widget.chittyId);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("BID NOW", style: TextStyle(fontSize: 12)),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: _statusColor(cycle.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cycle.status.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    ),
  );
}


  // 1. Standalone Success Dialog Method
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper: Data Container
  Widget _buildDataSection(
    String title,
    List<Widget> children, {
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  // Helper: Row Item
  Widget _rowItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Helper widget to display the details in the popup
  Widget _bidDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}