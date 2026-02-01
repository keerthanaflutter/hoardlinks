

import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chitty_agency_district_provider.dart';
import 'package:hoardlinks/views/home/spinning/advance_serch_widet.dart';
import 'package:hoardlinks/views/home/spinning/agency_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart'; 

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
    // Fetch agencies on load
    Future.microtask(() =>
        context.read<ChittyDistrictAgencyProvider>().fetchAgencies());
  }

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
      builder: (context) => AdvancedFilterSheet(),
      // Replace with your AdvancedFilterSheet() widget
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChittyDistrictAgencyProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
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
                      hintText: 'Search by Name or Contact...',
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
      return _buildShimmerLoading();
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    // Updated Filtering logic to include Trade Name and Contact Person
    final filteredAgencies = provider.agencies.where((agency) {
      final query = searchQuery.toLowerCase();
      return agency.legalName.toLowerCase().contains(query) ||
             agency.tradeName.toLowerCase().contains(query) ||
             agency.contactPerson.toLowerCase().contains(query);
    }).toList();

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
            backgroundColor: Color(0xFFF5F5F5),
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          title: Text(
            agency.legalName, // 1. Legal Name
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Color(0xFFCF202E),
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              // 2. Trade Name
              Text(
                agency.tradeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Colors.black87, 
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),
              const SizedBox(height: 2),
              // 3. Contact Person (Replaced Email)
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      agency.contactPerson,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 26),
                onPressed: () => _makePhoneCall(agency.contactPhone),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFFCF202E)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        itemCount: 8,
        separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 150, height: 18, color: Colors.white),
                      const SizedBox(height: 8),
                      Container(width: 100, height: 14, color: Colors.white),
                      const SizedBox(height: 4),
                      Container(width: 130, height: 13, color: Colors.white),
                    ],
                  ),
                ),
                const Icon(Icons.call, color: Colors.white, size: 26),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
              ],
            ),
          );
        },
      ),
    );
  }
}