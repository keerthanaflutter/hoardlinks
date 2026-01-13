import 'package:flutter/material.dart';
import 'package:hoardlinks/views/home/spinning/chitty_spinning_district_screen.dart';
import 'package:hoardlinks/views/home/spinning/chitty_spinning_state_screen.dart';

class BniSearchScreen extends StatefulWidget {
  const BniSearchScreen({super.key});

  @override
  _BniSearchScreenState createState() => _BniSearchScreenState();
}

class _BniSearchScreenState extends State<BniSearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // length: 2 as per your setup
    _tabController = TabController(length: 2, vsync: this);
    
    // Add listener to rebuild when tab changes to update background colors
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- 1. Custom Styled TabBar ---
          // Based on the image: Selected is Red/White text, Unselected is White/Red text
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorWeight: 0.1, // Hide default indicator line
              indicator: BoxDecoration(
                // This makes the selected tab have the red background
                color: const Color(0xFFCF202E),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFFCF202E),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: const [
                Tab(child: Center(child: Text('STATE SEARCH'))),
                Tab(child: Center(child: Text('DISTRICT SEARCH'))),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1),

          // --- 3. Tab Views ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Replace these with your actual Tab Widgets
                 SetStateSearchTab(),
                DistrictSearchTab(),
               
              ],
            ),
          ),

        ],
      ),
    );
  }
}
