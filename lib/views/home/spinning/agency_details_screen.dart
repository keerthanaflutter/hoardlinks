import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/agency_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// Replace these with your actual import paths
// import 'package:hoardlinks/providers/agency_detail_provider.dart'; 

class AgencyDetailScreen extends StatefulWidget {
  final int agencyId;

  const AgencyDetailScreen({super.key, required this.agencyId});

  @override
  State<AgencyDetailScreen> createState() => _AgencyDetailScreenState();
}

class _AgencyDetailScreenState extends State<AgencyDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch details immediately when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgencyDetailprovider>().fetchAgencyDetails(widget.agencyId);
    });
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AgencyDetailprovider>();
    final agency = provider.agencyDetail?.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agency Details"),
        backgroundColor: const Color(0xFFCF202E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFCF202E)))
          : agency == null
              ? const Center(child: Text("No details found"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildHeader(agency),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoCard(agency),
                            const SizedBox(height: 20),
                            _buildContactSection(agency),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(agency) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFCF202E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.business, size: 50, color: Color(0xFFCF202E)),
          ),
          const SizedBox(height: 15),
          Text(
            agency.legalName ?? "N/A",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "Code: ${agency.agencyCode ?? 'N/A'}",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(agency) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _detailRow(Icons.person, "Contact Person", agency.contactPerson),
            _detailRow(Icons.location_city, "City", agency.city),
            _detailRow(Icons.pin_drop, "Pincode", agency.pincode),
            _detailRow(Icons.receipt_long, "GST Number", agency.gstNumber),
            _detailRow(Icons.verified, "Status", agency.membershipStatus, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(agency) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _makePhoneCall(agency.contactPhone),
            icon: const Icon(Icons.call),
            label: const Text("Call Now"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {}, // Add email logic here if needed
            icon: const Icon(Icons.email),
            label: const Text("Email"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCF202E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String? value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              Text(
                value ?? "N/A",
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}