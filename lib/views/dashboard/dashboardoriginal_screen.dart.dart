
import 'package:flutter/material.dart';
import 'package:hoardlinks/core/constants/banner_const.dart';
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
      resizeToAvoidBottomInset: false, // Prevents the BNB from shifting when the keyboard appears
      appBar: AppBar(
        leadingWidth: size.width * 0.22,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: size.width * 0.03),
          child: Image.asset("assets/images/kaia_logo.png",
              width: size.width * 0.18, fit: BoxFit.contain),
        ),
        actions: [
          // Profile Icon in the AppBar
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.07),
            child: GestureDetector(
              onTap: () {
                // Navigate to Profile Screen when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfileScreen()),
                );
              },
              child: const Icon(Icons.account_circle, color: Colors.black, size: 30),
            ),
          ),
          // Notifications Icon
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.07),
            child: const Icon(Icons.notifications, color: Colors.black, size: 30),
          ),
        ],
      ),
      body: Stack(
        children: [
          /// 🔹 SCREEN CONTENT (The background screens)
          Positioned.fill(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),

          /// 🔴 BANNER (Only visible when Home Screen is selected)
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

          /// 🔻 BOTTOM NAV BAR
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// NAVIGATION BAR BACKGROUND
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

                  /// 🔴 MOVING CIRCLE INDICATOR
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
