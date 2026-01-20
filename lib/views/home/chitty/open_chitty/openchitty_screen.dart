import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/views/home/chitty/open_chitty/openchitty_card.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
// Import your provider and card paths

class OpenChittyScreen extends StatefulWidget {
  const OpenChittyScreen({super.key});

  @override
  State<OpenChittyScreen> createState() => _OpenChittyScreenState();
}

class _OpenChittyScreenState extends State<OpenChittyScreen> {
  bool _timerActive = true;

  @override
  void initState() {
    super.initState();
    // Start the 3-second "Minimum Shimmer Time" timer
    Timer(const Duration(seconds: 2), () {
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
        // Condition: Show shimmer if API is loading OR if our 3s timer is still running
        if (provider.isLoading || _timerActive) {
          return _buildShimmerLoading();
        }

        // Handle Error Case
        if (provider.error != null) {
          return Center(child: Text(provider.error!, style: const TextStyle(color: Colors.red)));
        }

        final list = provider.chittyResponse?.open ?? [];

        // Handle Empty Case
        if (list.isEmpty) {
          return _buildEmptyState();
        }

        // Handle Data List
        return RefreshIndicator(
          onRefresh: () => provider.fetchAllChitty(),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (_, index) {
              final item = list[index];
              return OpenChittyCard(item: item, statusColor: Colors.red);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFB11226).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.assignment_late_outlined, size: 80, color: Color(0xFFB11226)),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Open Chitty Available',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text('Try refreshing or check back later.', style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: 140,
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
                      Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 150, height: 15, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: 100, height: 12, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 80, height: 12, color: Colors.white),
                      Container(width: 60, height: 25, color: Colors.white),
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
