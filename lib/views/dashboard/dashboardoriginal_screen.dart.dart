import 'package:flutter/material.dart';
import 'package:hoardlinks/views/dashboard/drawer_widget.dart';
import 'package:hoardlinks/views/home/chitty/chittylist_screen.dart';
import 'package:hoardlinks/views/home/home_screen.dart';
import 'package:hoardlinks/views/home/profile/profile_screen.dart';
import 'package:hoardlinks/views/home/spinning/chitty_spinning_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int selectedIndex;
  const DashboardScreen({super.key, this.selectedIndex = 1});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;

  // 1. THE SCREENS MAPPED TO NAVIGATION
  final List<Widget> _pages = [
    const BniSearchScreen(),
    const HomeScreen(),
    const ChittyScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  // Logic for the floating circle position
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,

      // --- THE DRAWER ---
      drawer: const CustomDrawer(),

      // --- THE APPBAR ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Image.asset(
            "assets/images/kaia_logo.png",
            height: 35,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.account_circle,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: const Icon(
              Icons.notifications,
              color: Colors.black,
              size: 30,
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          /// --- LAYER 1: THE BOTTOM BANNER IMAGE ---
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: size.width,
              height: size.height * 0.60,
              child: Image.asset(
                "assets/images/banner.jpg",
                alignment: Alignment.bottomCenter,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// --- LAYER 2: THE FULL SCREEN GREY OVERLAY ---
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 241, 241, 241).withOpacity(0.5),
            ),
          ),

          /// --- LAYER 3: THE ACTUAL CONTENT SCREENS ---
          Positioned.fill(
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),

          /// --- LAYER 4: CUSTOM BOTTOM NAVIGATION BAR ---
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _buildBottomNavigationBar(),
          ),
        ],
      ),
    );
  }

  /// Refactored Bottom Navigation Bar Widget
  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Bar
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                colors: [Color(0xFFB11226), Color.fromARGB(255, 99, 82, 84)],
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
                _navItemAsset("assets/images/kaia_logo.png", 0),
                _navItemAsset("assets/images/house.png", 1),
                _navItemAsset("assets/images/chittyicon.png", 2),
              ],
            ),
          ),

          // Sliding Selector Circle
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
                        : "assets/images/chittyicon.png",
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
    );
  }

  // Nav Item Helper
  Widget _navItemAsset(String asset, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Opacity(
        opacity: isSelected
            ? 0.0
            : 1.0, // Hide the icon in the bar if the circle is over it
        child: Image.asset(asset, height: 26, color: Colors.white70),
      ),
    );
  }
}
