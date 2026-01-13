import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/views/home/chitty/card_widget.dart';
import 'package:provider/provider.dart';

class ClosedChittyScreen extends StatelessWidget {
  const ClosedChittyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChittyProvider>(
      builder: (context, provider, _) {
        final list = provider.chittyResponse?.closed ?? [];

        if (list.isEmpty) {
          return const Center(child: Text('No Closed Chitty'));
        }

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
}
