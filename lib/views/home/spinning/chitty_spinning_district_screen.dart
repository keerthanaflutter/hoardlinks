

import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chitty_agency_district_provider.dart';
import 'package:hoardlinks/views/home/spinning/advance_serch_widet.dart';
import 'package:hoardlinks/views/home/spinning/agency_details_screen.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

class DistrictSearchTab extends StatefulWidget {
  const DistrictSearchTab({super.key});

  @override
  _DistrictSearchTabState createState() => _DistrictSearchTabState();
}

class _DistrictSearchTabState extends State<DistrictSearchTab> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<ChittyDistrictAgencyProvider>().fetchAgencies());
  }

  // Helper to launch phone dialer from the list
  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AdvancedFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChittyDistrictAgencyProvider>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // --- Search Bar Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: _showFilterSheet,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFCF202E)),
                  onPressed: () {}, 
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),

          Expanded(
            child: _buildBody(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ChittyDistrictAgencyProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    final filteredAgencies = provider.agencies
        .where((agency) =>
            agency.legalName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    if (filteredAgencies.isEmpty) {
      return const Center(child: Text("No agencies found."));
    }

    return ListView.separated(
      itemCount: filteredAgencies.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final agency = filteredAgencies[index];
        return ListTile(
          onTap: () {
            // Navigate to Details Screen passing the ID
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgencyDetailScreen(agencyId: agency.id),
              ),
            );
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          title: Text(
            agency.legalName,
            style: const TextStyle(
                color: Color(0xFFCF202E),
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(agency.tradeName,
                  style: const TextStyle(color: Colors.black87, fontSize: 14)),
              Text(agency.contactEmail,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 26),
                onPressed: () => _makePhoneCall(agency.contactPhone),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCF202E)),
            ],
          ),
        );
      },
    );
  }
}