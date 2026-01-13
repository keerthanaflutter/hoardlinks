import 'package:flutter/material.dart';
import 'package:hoardlinks/data/models/chittylist_model.dart';
import 'package:hoardlinks/viewmodels/chittydetails_provider.dart';
import 'package:hoardlinks/views/home/chitty/open_chitty/oprnchitty_popupwidget.dart';
import 'package:provider/provider.dart';

class OpenChittyCard extends StatelessWidget {
  final ChittyScheme item;
  final Color statusColor;

  const OpenChittyCard({
    super.key,
    required this.item,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {
          _openDetailsPopup(context, item.id);
        },
        title: Text(
          item.schemeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Monthly: ₹${item.monthlyAmount}\n'
          'Duration: ${item.durationMonths} months',
        ),
        trailing: Text(
          item.status,
          style: TextStyle(
            color: statusColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _openDetailsPopup(BuildContext context, int chittyId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return ChangeNotifierProvider(
          create: (_) => ChittyDetailsProvider()
            ..fetchChittyDetails(chittyId),
          child: const ChittyDetailsPopup(),
        );
      },
    );
  }
}
