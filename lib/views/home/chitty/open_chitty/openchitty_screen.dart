import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/views/home/chitty/open_chitty/openchitty_card.dart';
import 'package:provider/provider.dart';

class OpenChittyScreen extends StatefulWidget {
  const OpenChittyScreen({super.key});

  @override
  State<OpenChittyScreen> createState() => _OpenChittyScreenState();
}

class _OpenChittyScreenState extends State<OpenChittyScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChittyProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final list = provider.chittyResponse?.open ?? [];

        if (list.isEmpty) {
          return const Center(child: Text('No Open Chitty'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (_, index) {
            final item = list[index];
            return OpenChittyCard(item: item, statusColor: Colors.red);
          },
        );
      },
    );
  }
}
