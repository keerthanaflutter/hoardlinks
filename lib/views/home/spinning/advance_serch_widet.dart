import 'package:flutter/material.dart';
import 'package:hoardlinks/data/models/chitty_agency_district_model.dart';
import 'package:hoardlinks/viewmodels/advanced_serch_provider.dart';
import 'package:hoardlinks/viewmodels/district_get_provider.dart';
import 'package:hoardlinks/views/home/spinning/agency_details_screen.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AdvancedFilterSheet extends StatefulWidget {
  const AdvancedFilterSheet({super.key});

  @override
  State<AdvancedFilterSheet> createState() => _AdvancedFilterSheetState();
}

class _AdvancedFilterSheetState extends State<AdvancedFilterSheet> {
  final TextEditingController _firstNameController = TextEditingController();
  int? _selectedDistrictId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DistrictGetProvider>().fetchDistricts();
      context.read<AdvanceSearchProvider>().clearSearch();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }

  void _handleClose(BuildContext context) {
    context.read<AdvanceSearchProvider>().clearSearch();
    Navigator.pop(context);
  }

  // 🔥 Working Phone Dialer Logic
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open dialer: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<AdvanceSearchProvider>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) context.read<AdvanceSearchProvider>().clearSearch();
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                _buildPullHandle(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildSectionTitle("Search Parameters"),
                        _buildDistrictDropdown(),
                        const SizedBox(height: 16),
                        _buildFilterField("Agency Name", _firstNameController),
                        const SizedBox(height: 20),
                        _buildSearchButton(searchProvider),
                        const SizedBox(height: 30),
                        const Divider(),
                        _buildSectionTitle("Search Results"),
                        _buildResponseUI(searchProvider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResponseUI(AdvanceSearchProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: CircularProgressIndicator(color: Color(0xFFCF202E)),
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (provider.searchResults.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No agencies found.", style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.searchResults.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final Agency agency = provider.searchResults[index];

        return ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            // 🔥 Passing only the agencyId to the detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgencyDetailScreen(agencyId: agency.id),
              ),
            );
          },
          title: Text(
            agency.tradeName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Text(
            agency.legalName,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 20),
                onPressed: () => _makePhoneCall(agency.contactPhone),
              ),
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchButton(AdvanceSearchProvider searchProvider) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCF202E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: searchProvider.isLoading
            ? null
            : () async {
                await searchProvider.performAdvancedSearch(
                  queryName: _firstNameController.text.trim(),
                  customDistrictId: _selectedDistrictId,
                );
              },
        child: searchProvider.isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text(
                "SEARCH NOW",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildDistrictDropdown() {
    return Consumer<DistrictGetProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _selectedDistrictId,
              isExpanded: true,
              hint: const Text("Filter by District"),
              items: provider.districts.map((district) {
                return DropdownMenuItem<int>(
                  value: district.id,
                  child: Text(district.districtName),
                );
              }).toList(),
              onChanged: (int? newValue) => setState(() => _selectedDistrictId = newValue),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPullHandle() => Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Center(
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget _buildHeader(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Advanced Search",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFCF202E)),
          ),
          IconButton(
            onPressed: () => _handleClose(context),
            icon: const Icon(Icons.close),
          ),
        ],
      );

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
        ),
      );

  Widget _buildFilterField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}