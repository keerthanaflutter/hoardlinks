
import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyscheem_get_provider.dart';
import 'package:hoardlinks/views/home/spinning/agency_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import for calling functionality

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
    // Fetch agencies when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgencyProvider>().fetchAgencies();
    });
  }

  // Function to launch the phone dialer
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
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

    if (agencyProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (agencyProvider.errorMessage.isNotEmpty) {
      return Center(child: Text(agencyProvider.errorMessage));
    }

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

        // --- List of Agencies ---
        Expanded(
          child: ListView.separated(
            itemCount: filteredAgencies.length,
            separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
            itemBuilder: (context, index) {
              final agency = filteredAgencies[index];
              
              return InkWell(
                // Navigate to Details Screen on row tap
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
                      Text(
                        agency.tradeName,
                        style: const TextStyle(color: Colors.black87, fontSize: 14),
                      ),
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
                      // CALL ICON BUTTON
                      IconButton(
                        icon: const Icon(Icons.call, color: Colors.green, size: 28),
                        onPressed: () {
                          // Prevent the ListTile onTap from firing when clicking the icon
                          _makePhoneCall(agency.contactPhone);
                        },
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCF202E)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
