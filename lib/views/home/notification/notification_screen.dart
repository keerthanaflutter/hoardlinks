// notification_screen.dart
import 'package:flutter/material.dart';

import 'package:hoardlinks/views/dashboard/dashboardoriginal_screen.dart.dart';

class NotificationScreen extends StatelessWidget {
  final String? title;
  final String? body;

  const NotificationScreen({
    super.key,
    this.title,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 🔑 Clear stack and go to Dashboard
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
          (route) => false,
        );
        return false; // prevent default pop
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notification"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (_) => const DashboardScreen()),
                (route) => false,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "No Title",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body ?? "No Body",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ChittyApprovedScreen extends StatelessWidget {
  final int chittyId;
  final int memberId;

  const ChittyApprovedScreen({
    required this.chittyId,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chitty Approved'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chitty ID: $chittyId'),
            Text('Member ID: $memberId'),
            // Add further details here
          ],
        ),
      ),
    );
  }
}



class ChittyRejectedScreen extends StatelessWidget {
  final int chittyId;
  final int memberId;

  const ChittyRejectedScreen({
    required this.chittyId,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chitty Rejected'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chitty ID: $chittyId'),
            Text('Member ID: $memberId'),
            // Add further details here
          ],
        ),
      ),
    );
  }
}
