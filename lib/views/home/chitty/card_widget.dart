import 'package:flutter/material.dart';
import 'package:hoardlinks/data/models/chittylist_model.dart';

class ChittyCard extends StatelessWidget {
  final ChittyScheme item;
  final Color statusColor;

  const ChittyCard({
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
          _showPopup(context);
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

  void _showPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            "Hi 👋",
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
