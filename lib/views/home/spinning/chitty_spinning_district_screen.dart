import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chitty_agency_district_provider.dart'; // Correct import
import 'package:provider/provider.dart';

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
    // Fetch agencies when the screen loads
    final chittyDistrictAgencyProvider = context.read<ChittyDistrictAgencyProvider>();
    chittyDistrictAgencyProvider.fetchAgencies();
  }

  @override
  Widget build(BuildContext context) {
    final chittyDistrictAgencyProvider = context.watch<ChittyDistrictAgencyProvider>();

    // Show loading indicator when agencies are being fetched
    if (chittyDistrictAgencyProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error message if there was an issue fetching agencies
    if (chittyDistrictAgencyProvider.error != null) {
      return Center(child: Text(chittyDistrictAgencyProvider.error!));
    }

    // Get the agencies list from the provider
    final agencies = chittyDistrictAgencyProvider.agencies;

    // Filter agencies based on the search query
    final filteredAgencies = agencies
        .where((agency) => agency.legalName
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents the BNB from shifting when the keyboard appears
      body: Column(
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
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFCF202E)),
                  onPressed: () {
                    // Print the search query and reload the screen
                    print("Search Query: $searchQuery");
                    setState(() {
                      // This will trigger the reload by updating the filtered agencies
                    });
                  },
                ),
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
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                  ),
                  title: Text(
                    agency.legalName,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 107, 133, 250),
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
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCF202E)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

