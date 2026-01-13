import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/views/home/chitty/chittydetails_screen.dart';
import 'package:provider/provider.dart';

class RunningChittyScreen extends StatelessWidget {
  const RunningChittyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChittyProvider>(
      builder: (context, provider, _) {
        final list = provider.chittyResponse?.running ?? [];

        if (list.isEmpty) {
          return const Center(child: Text('No Running Chitty'));
        }

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
                      chittyId: item.id, // ✅ CORRECT
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

