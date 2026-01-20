import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/views/home/chitty/card_widget.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
// Import your provider and card paths here

class ClosedChittyScreen extends StatefulWidget {
  const ClosedChittyScreen({super.key});

  @override
  State<ClosedChittyScreen> createState() => _ClosedChittyScreenState();
}

class _ClosedChittyScreenState extends State<ClosedChittyScreen> {
  bool _timerActive = true;

  @override
  void initState() {
    super.initState();
    // Ensures shimmer stays for 3 seconds to match the other tabs
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
        // Show shimmer if API is loading OR the 3s timer is active
        if (provider.isLoading || _timerActive) {
          return _buildShimmerLoading();
        }

        final list = provider.chittyResponse?.closed ?? [];

        // Attractive Empty State for Closed Chitties
        if (list.isEmpty) {
          return _buildEmptyState();
        }

        // Data List
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (_, index) {
            final item = list[index];
            return ChittyCard(item: item, statusColor: Colors.grey);
          },
        );
      },
    );
  }

  /// Attractive Empty State UI (Grey Theme for "Closed")
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_rounded, // Relevant icon for history/closed
              size: 70,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No History Found',
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
              'You don’t have any closed or completed chitties yet.',
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
            height: 140, // Match ChittyCard height
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 140, height: 18, color: Colors.white),
                          const SizedBox(height: 10),
                          Container(width: 80, height: 14, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 100, height: 14, color: Colors.white),
                      Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
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