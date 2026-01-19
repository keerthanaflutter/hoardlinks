import 'package:flutter/material.dart';
import 'package:hoardlinks/viewmodels/chittyget_provider.dart';
import 'package:hoardlinks/views/home/chitty/closedchitty_screen.dart';
import 'package:hoardlinks/views/home/chitty/open_chitty/openchitty_screen.dart';
import 'package:hoardlinks/views/home/chitty/runningchitty/runningchitty_screen.dart';
import 'package:provider/provider.dart';

class ChittyScreen extends StatefulWidget {
  const ChittyScreen({super.key,});

  @override
  State<ChittyScreen> createState() => _ChittyScreenState();
}

class _ChittyScreenState extends State<ChittyScreen> {
  static const primaryColor = Color(0xFFB11226);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChittyProvider>().fetchAllChitty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              /// 🔴 HEADER
              Container(
                color: primaryColor,
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: const TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(text: 'OPEN'),
                    Tab(text: 'RUNNING'),
                    Tab(text: 'CLOSED'),
                  ],
                ),
              ),

              /// 🔴 TAB SCREENS
              const Expanded(
                child: TabBarView(
                  children: [
                    OpenChittyScreen(),
                    RunningChittyScreen(),
                    ClosedChittyScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
