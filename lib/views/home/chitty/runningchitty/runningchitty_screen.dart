import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/views/home/chitty/chittydetails_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
// Import your provider, card, and detail screen paths here

class RunningChittyScreen extends StatefulWidget {
  const RunningChittyScreen({super.key});

  @override
  State<RunningChittyScreen> createState() => _RunningChittyScreenState();
}

class _RunningChittyScreenState extends State<RunningChittyScreen> {
  bool _timerActive = true;

  @override
  void initState() {
    super.initState();
    // Force the shimmer to show for exactly 3 seconds on first load
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _timerActive = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChittyProvider>(
      builder: (context, provider, _) {
        // Show shimmer if API is loading OR our 3s timer is still running
        if (provider.isLoading || _timerActive) {
          return _buildShimmerLoading();
        }

        final list = provider.chittyResponse?.running ?? [];

        // Attractive Empty State
        if (list.isEmpty) {
          return _buildEmptyState();
        }

        // Main List
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (_, index) {
            final item = list[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChittyDetailsScreen(
                      chittyId: item.id,
                    ),
                  ),
                );
              },
              child: RunningChittyCard(
                item: item,
                statusColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }

  /// Attractive Empty State UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1), // Using Green for Running Tab
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up_rounded, // Relevant icon for "Running"
              size: 70,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Active Chitties',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'You don’t have any chitties running right now. Join an open chitty to get started!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shimmer Skeleton Loader
  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: 140, // Match your RunningChittyCard height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 55, 
                        height: 55, 
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 160, height: 18, color: Colors.white),
                          const SizedBox(height: 10),
                          Container(width: 90, height: 14, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 110, height: 14, color: Colors.white),
                      Container(
                        width: 70, 
                        height: 30, 
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class RunningChittyCard extends StatefulWidget {
  final dynamic item;
  final Color statusColor;

  const RunningChittyCard({
    super.key,
    required this.item,
    required this.statusColor,
  });

  @override
  _RunningChittyCardState createState() => _RunningChittyCardState();
}

class _RunningChittyCardState extends State<RunningChittyCard> {
  Timer? _timer;
  Duration _remainingTime = Duration.zero;
  bool _isLotTimeReached = false;

  @override
  void initState() {
    super.initState();
    // 1. Calculate immediately so the screen doesn't show 00:00:00 on load
    _updateRemainingTime();
    
    // 2. Start the periodic timer
    _startTimer();
  }

  /// Normalizes the API time and calculates the difference from NOW
  void _updateRemainingTime() {
    final DateTime now = DateTime.now();
    final DateTime rawTime = widget.item.lotTime;
    DateTime targetTime;

    // Normalize 1970 dates to today/tomorrow
    if (rawTime.year == 1970) {
      targetTime = DateTime(
        now.year,
        now.month,
        now.day,
        rawTime.hour,
        rawTime.minute,
        rawTime.second,
      );
      // If the time has already passed today, calculate for tomorrow
      if (targetTime.isBefore(now)) {
        targetTime = targetTime.add(const Duration(days: 1));
      }
    } else {
      targetTime = rawTime;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Formatted String HH:MM:SS
    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    final String lotTimeText = _isLotTimeReached 
        ? "Lot Time Reached" 
        : "$hours:$minutes:$seconds";

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          widget.item.schemeName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly: ₹${widget.item.monthlyAmount}\n'
                'Duration: ${widget.item.durationMonths} months',
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('Lot Time: ', style: TextStyle(fontSize: 13)),
                  Text(
                    lotTimeText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isLotTimeReached ? Colors.green : Colors.red,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.item.status,
              style: TextStyle(
                color: widget.statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}

