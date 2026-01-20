
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/banner_const.dart';
import 'package:hoardlinks/views/dashboard/drawer_widget.dart';
import 'package:hoardlinks/views/home/chitty/chittylist_screen.dart';
import 'package:hoardlinks/views/home/home_screen.dart';
import 'package:hoardlinks/views/home/profile/profile_screen.dart';
import 'package:hoardlinks/views/home/spinning/chitty_spinning_screen.dart';

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final int selectedIndex;

  const DashboardScreen({super.key, this.selectedIndex = 1});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  // The pages used in the IndexedStack
  final List<Widget> _pages = [
    const BniSearchScreen(),
    const HomeScreen(),
    const ChittyScreen(),
  ];

  Alignment _getAlignment() {
    switch (_selectedIndex) {
      case 0:
        return Alignment.centerLeft;
      case 1:
        return Alignment.center;
      case 2:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // --- THE DRAWER ---
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false, // Keeps logo on the left side
        // --- 1. SEPARATE DRAWER ICON ---
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        // --- 2. LOGO MOVED TO TITLE ---
        titleSpacing: 0, // Removes gap between menu icon and logo
        title: Image.asset(
          "assets/images/kaia_logo.png",
          height: 35, // Adjusted size to fit nicely in AppBar
          fit: BoxFit.contain,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
              child: const Icon(Icons.account_circle, color: Colors.black, size: 30),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: const Icon(Icons.notifications, color: Colors.black, size: 30),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
          if (_selectedIndex == 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: size.height * 0.30,
                child: CustomPaint(
                  painter: BottomBannerPainter(),
                ),
              ),
            ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFB11226),
                          Color.fromARGB(255, 99, 82, 84),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _pngIcon("assets/images/kaia_logo.png", 0),
                        _buildPngIcon("assets/images/house.png", 1),
                        _buildPngIcon("assets/images/user.png", 2),
                      ],
                    ),
                  ),
                  AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    alignment: _getAlignment(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 155, 69, 80),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            _selectedIndex == 0
                                ? "assets/images/kaia_logo.png"
                                : _selectedIndex == 1
                                    ? "assets/images/house.png"
                                    : "assets/images/user.png",
                            height: 28,
                            width: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPngIcon(String asset, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Image.asset(
        asset,
        height: 26,
        color: Colors.white70,
      ),
    );
  }

  Widget _pngIcon(String asset, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Image.asset(
        asset,
        height: 26,
        color: Colors.white,
      ),
    );
  }
}

