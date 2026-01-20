
import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyscheem_get_provider.dart';
import 'package:hoardlinks/views/home/spinning/agency_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for calling functionality
import 'package:shimmer/shimmer.dart'; 

class SetStateSearchTab extends StatefulWidget {
  const SetStateSearchTab({super.key});

  @override
  _SetStateSearchTabState createState() => _SetStateSearchTabState();
}

class _SetStateSearchTabState extends State<SetStateSearchTab> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgencyProvider>().fetchAgencies();
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final agencyProvider = context.watch<AgencyProvider>();

    // Filtering logic moved above the return to keep the build method clean
    final filteredAgencies = agencyProvider.agencies
        .where((agency) => agency.legalName
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        // --- Search Bar Section ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by Name, Specialty...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const Icon(Icons.mail_outline, color: Color(0xFFCF202E), size: 28),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),

        // --- Content Section ---
        Expanded(
          child: _buildContent(agencyProvider, filteredAgencies),
        ),
      ],
    );
  }

  // Helper method to decide what to show in the list area
  Widget _buildContent(AgencyProvider provider, List filteredAgencies) {
    if (provider.isLoading) {
      return _buildShimmerList(); // Show Shimmer when loading
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(child: Text(provider.errorMessage));
    }

    if (filteredAgencies.isEmpty) {
      return const Center(child: Text("No agencies found."));
    }

    return ListView.separated(
      itemCount: filteredAgencies.length,
      separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
      itemBuilder: (context, index) {
        final agency = filteredAgencies[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgencyDetailScreen(agencyId: agency.id),
              ),
            );
          },
          child: ListTile(
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
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(agency.tradeName, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                Text(
                  agency.contactEmail,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green, size: 28),
                  onPressed: () => _makePhoneCall(agency.contactPhone),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCF202E)),
              ],
            ),
          ),
        );
      },
    );
  }

  // The Shimmer Effect UI
  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        itemCount: 6, // Show 6 skeleton items
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
                      Container(width: 180, height: 12, color: Colors.white),
                    ],
                  ),
                ),
                Container(width: 40, height: 40, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ],
            ),
          );
        },
      ),
    );
  }
}