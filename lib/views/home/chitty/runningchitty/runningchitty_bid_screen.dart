import 'package:flutter/material.dart';
import 'package:hoardlinks/data/models/chittydetails_model.dart';
import 'package:hoardlinks/viewmodels/aution_provider.dart';
import 'package:hoardlinks/viewmodels/chitttybig_provider.dart';
import 'package:provider/provider.dart';
class BidPopupBottomSheet extends StatefulWidget {
  final Chitty chitty;
  final ChittyCycle cycle;
  final String memberNo;
  final String duration;

  const BidPopupBottomSheet({
    super.key,
    required this.chitty,
    required this.cycle,
    required this.memberNo,
    required this.duration,
  });

  @override
  State<BidPopupBottomSheet> createState() => _BidPopupBottomSheetState();
}

class _BidPopupBottomSheetState extends State<BidPopupBottomSheet> {
  final TextEditingController _bidController = TextEditingController();

  @override
  void dispose() {
    _bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuctionIdProvider, ChittyBidProvider>(
      builder: (context, auctionProvider, bidProvider, child) {
        // --- 1. SUCCESS VIEW (Centered Message) ---
        if (bidProvider.isBidSuccessful) {
          // Refresh ChittyDetailScreen after successful bid
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context); // Close the bottom sheet
          });

          return Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                const Text(
                  "SUCCESS!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 8),
                Text(
                  bidProvider.successMessage ?? "Your bid has been placed successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("CLOSE", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        }

        // --- 2. INITIAL LOADING (Auction Info) ---
        if (auctionProvider.isLoading) {
          return const SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // --- 3. ERROR HANDLING ---
        if (auctionProvider.errorMessage != null) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            child: Center(child: Text("Error: ${auctionProvider.errorMessage}")),
          );
        }

        final bidData = auctionProvider.bidData;
        if (bidData == null) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No auction data available."),
          );
        }

        // --- 4. MAIN BIDDING FORM ---
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Place Your Bid - Cycle ${widget.cycle.cycleNo}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  children: [
                    // _infoChip("Auction ID: ${bidData.id}"),
                    // _infoChip("Duration: ${widget.duration}"),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _bidController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                  decoration: InputDecoration(
                    prefixText: "₹ ",
                    hintText: "Enter Amount",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (bidProvider.error != null) ...[
                  const SizedBox(height: 8),
                  Text(bidProvider.error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: bidProvider.isLoading
                        ? null
                        : () async {
                            double? bidAmount = double.tryParse(_bidController.text);
                            if (bidAmount == null || bidAmount <= 0) {
                              _showSnackBar(context, "Enter a valid amount", isError: true);
                              return;
                            }

                            await bidProvider.sendBid(
                              auctionId: bidData.id,
                              chittyId: widget.chitty.id,
                              memberNo: int.parse(widget.memberNo),
                              monthIndex: widget.cycle.cycleNo,
                              bidAmount: bidAmount,
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB11226),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: bidProvider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("SUBMIT BID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _infoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: Colors.blueGrey[700])),
    );
  }
}
